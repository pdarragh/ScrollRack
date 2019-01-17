//
//  DeckFolderWithChildrenResponse.swift
//  App
//
//  Created by Pierce Darragh on 1/10/19.
//

import Vapor

final class DeckFolderWithChildrenResponse: Content {
    var name: String
    var userIndex: Int
    var childDecks: [Deck]
    var childDeckFolders: [DeckFolder]

    init(name: String, userIndex: Int, childDecks: [Deck], childDeckFolders: [DeckFolder]) {
        self.name = name
        self.userIndex = userIndex
        self.childDecks = childDecks
        self.childDeckFolders = childDeckFolders
    }
}

extension Future where T: DeckFolder {
    func toResponseWithChildren(on req: Request) -> Future<DeckFolderWithChildrenResponse> {
        return flatMap(to: DeckFolderWithChildrenResponse.self) { deckFolder in
            return try deckFolder.subFolders.query(on: req).all().flatMap { subFolders in
                return try deckFolder.superFolders.query(on: req).all().flatMap { superFolders in
                    return try deckFolder.decks.query(on: req).all().map { decks in
                        return DeckFolderWithChildrenResponse(name: deckFolder.name, userIndex: deckFolder.userIndex, childDecks: decks, childDeckFolders: subFolders)
                    }
                }
            }
        }
    }
}
