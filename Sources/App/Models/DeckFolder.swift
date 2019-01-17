//
//  DeckFolder.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import FluentMySQL
import Vapor

final class DeckFolder: MySQLModel {
    static let entity = "deck_folders"

    var id: Int?
    var name: String
    var userID: Int
    var userIndex: Int

    init(id: Int? = nil, name: String, userID: Int, userIndex: Int) {
        self.id = id
        self.name = name
        self.userID = userID
        self.userIndex = userIndex
    }
}

extension DeckFolder: Content {}

extension DeckFolder {
    var decks: Siblings<DeckFolder, Deck, DeckFoldersToDecksPivot> {
        return siblings()
    }

    var subFolders: Siblings<DeckFolder, DeckFolder, DeckFoldersToSubfoldersPivot> {
        return childrenSiblings()
    }

    var superFolders: Siblings<DeckFolder, DeckFolder, DeckFoldersToSubfoldersPivot> {
        return parentSiblings()
    }
}

struct CreateDeckFolder: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(DeckFolder.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name, type: .varchar(32))
            builder.field(for: \.userID)
            builder.field(for: \.userIndex)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(DeckFolder.self, on: conn)
    }
}
