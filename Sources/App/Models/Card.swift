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
    var oracleID: UUID
    var scryfallID: UUID?
    var condition: Int?
    var foil: Bool?
    var added: Date?
    var modified: Date?
    var userID: Int?
    var userIndex: Int?
    var extraInfo: String?

    init(id: Int? = nil, oracleID: UUID, scryfallID: UUID?, condition: Int?, foil: Bool?, userID: Int?, userIndex: Int?, extraInfo: String?) {
        self.id = id
        self.oracleID = oracleID
        self.scryfallID = scryfallID
        self.condition = condition
        self.foil = foil
        self.added = Date()
        self.modified = Date()
        self.userID = userID
        self.userIndex = userIndex
        self.extraInfo = extraInfo
    }
}

extension Card: Content {}

extension Card {
    var collections: Siblings<Card, Collection, CardsToCollectionsPivot> {
        return siblings()
    }
}

struct CreateCard: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(Card.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.oracleID)
            builder.field(for: \.scryfallID)
            builder.field(for: \.condition, type: .tinyint(4))
            builder.field(for: \.foil)
            builder.field(for: \.added, type: .timestamp)
            builder.field(for: \.modified, type: .timestamp)
            builder.field(for: \.userID)
            builder.field(for: \.userIndex)
            builder.field(for: \.extraInfo)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(Card.self, on: conn)
    }
}
