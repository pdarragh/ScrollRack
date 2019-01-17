//
//  DeckFoldersToDecksPivot.swift
//  App
//
//  Created by Pierce Darragh on 1/9/19.
//

import FluentMySQL
import Vapor

final class DeckFoldersToDecksPivot: MySQLPivot {
    static let entity = "deck_folders_TO_decks"

    typealias Left = DeckFolder
    typealias Right = Deck

    static var leftIDKey: LeftIDKey = \.deckFolderID
    static var rightIDKey: RightIDKey = \.deckID

    var id: Int?
    var deckFolderID: Int
    var deckID: Int

    init(deckFolderID: Int, deckID: Int) {
        self.deckFolderID = deckFolderID
        self.deckID = deckID
    }
}

extension DeckFoldersToDecksPivot: MySQLMigration {}
