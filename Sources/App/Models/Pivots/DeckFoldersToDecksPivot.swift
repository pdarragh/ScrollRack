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

    static var leftIDKey: LeftIDKey = \.deck_folder_id
    static var rightIDKey: RightIDKey = \.deck_id

    var id: Int?
    var deck_folder_id: Int
    var deck_id: Int

    init(deck_folder_id: Int, deck_id: Int) {
        self.deck_folder_id = deck_folder_id
        self.deck_id = deck_id
    }
}

extension DeckFoldersToDecksPivot: MySQLMigration {}
