//
//  DeckFolderWithChildrenResponse.swift
//  App
//
//  Created by Pierce Darragh on 1/10/19.
//

import Vapor

final class DeckFolderWithChildrenResponse: Content {
    var name: String
    var user_index: Int
    var decks: [Deck]
    var sub_folders: [DeckFolder]

    init(name: String, user_index: Int, decks: [Deck], sub_folders: [DeckFolder]) {
        self.name = name
        self.user_index = user_index
        self.decks = decks
        self.sub_folders = sub_folders
    }
}

extension Future where T: DeckFolder {
    func toResponseWithChildren(on req: Request) -> Future<DeckFolderWithChildrenResponse> {
        return flatMap(to: DeckFolderWithChildrenResponse.self) { deckFolder in
            return try deckFolder.subFolders.query(on: req).all().flatMap { subFolders in
                return try deckFolder.superFolders.query(on: req).all().flatMap { superFolders in
                    return try deckFolder.decks.query(on: req).all().map { decks in
                        return DeckFolderWithChildrenResponse(name: deckFolder.name, user_index: deckFolder.user_index, decks: decks, sub_folders: subFolders)
                    }
                }
            }
        }
    }
}
