//
//  Deck.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import FluentMySQL
import Vapor

final class Deck: MySQLModel {
    static let entity = "decks"

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

extension Deck: Content {}

extension Deck {
    var deck_folders: Siblings<Deck, DeckFolder, DeckFoldersToDecksPivot> {
        return siblings()
    }
}

struct CreateDeck: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(Deck.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name, type: .varchar(32))
            builder.field(for: \.userID)
            builder.field(for: \.userIndex)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(Deck.self, on: conn)
    }
}
