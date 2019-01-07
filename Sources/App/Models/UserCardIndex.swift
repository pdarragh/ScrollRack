//
//  UserCardIndex.swift
//  App
//
//  Created by Pierce Darragh on 1/5/19.
//

import FluentMySQL
import Vapor

final class UserCardIndex: MySQLModel {
    static let entity = "user_card_indices"

    var id: Int?
    var user_id: Int
    var next_index: Int

    init(id: Int? = nil, user_id: Int, next_index: Int) {
        self.id = id
        self.user_id = user_id
        self.next_index = next_index
    }
}

extension UserCardIndex: Content {}
extension UserCardIndex: Parameter {}

struct CreateUserCardIndex: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(UserCardIndex.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.user_id)
            builder.field(for: \.next_index)

            builder.unique(on: \.user_id)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(UserCardIndex.self, on: conn)
    }
}
