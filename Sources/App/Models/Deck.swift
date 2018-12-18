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
    var user_id: Int
    var user_index: Int

    init(id: Int? = nil, name: String, user_id: Int, user_index: Int) {
        self.id = id
        self.name = name
        self.user_id = user_id
        self.user_index = user_index
    }
}

extension Deck: Content {}
extension Deck: Parameter {}

struct CreateDeck: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(Deck.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name, type: .varchar(32))
            builder.field(for: \.user_id)
            builder.field(for: \.user_index)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(Deck.self, on: conn)
    }
}
