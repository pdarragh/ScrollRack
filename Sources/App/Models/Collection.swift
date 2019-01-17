//
//  Collection.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import FluentMySQL
import Vapor

final class Collection: MySQLModel {
    static let entity = "collections"

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

extension Collection: Content {}

extension Collection {
    var cards: Siblings<Collection, Card, CardsToCollectionsPivot> {
        return siblings()
    }
}

struct CreateCollection: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(Collection.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name, type: .varchar(32))
            builder.field(for: \.userID)
            builder.field(for: \.userIndex)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(Collection.self, on: conn)
    }
}
