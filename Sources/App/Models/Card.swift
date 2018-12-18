//
//  Cards.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import FluentMySQL
import Vapor

final class Card: MySQLModel {
    static let entity = "cards"

    var id: Int?
    var scryfall_id: UUID
    var play_condition: Int
    var foil: Bool
    var added: Date
    var modified: Date
    var user_id: Int
    var user_index: Int

    init(id: Int? = nil, scryfall_id: UUID, play_condition: Int, foil: Bool, added: Date, modified: Date, user_id: Int, user_index: Int) {
        self.id = id
        self.scryfall_id = scryfall_id
        self.play_condition = play_condition
        self.foil = foil
        self.added = added
        self.modified = modified
        self.user_id = user_id
        self.user_index = user_index
    }
}

extension Card: Content {}
extension Card: Parameter {}

struct CreateCard: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(Card.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.scryfall_id)
            builder.field(for: \.play_condition, type: .tinyint(4))
            builder.field(for: \.foil)
            builder.field(for: \.added, type: .timestamp)
            builder.field(for: \.modified, type: .timestamp)
            builder.field(for: \.user_id)
            builder.field(for: \.user_index)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(Card.self, on: conn)
    }
}
