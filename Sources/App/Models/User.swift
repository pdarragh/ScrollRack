//
//  User.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import Authentication
import FluentMySQL
import Vapor

final class User: MySQLModel {
    static let entity = "users"

    var id: Int?
    var username: String
    var pw_hash: String
    var email: String
    var next_card_index: Int
    var next_collection_index: Int
    var next_deck_index: Int
    var next_deck_folder_index: Int

    init(id: Int? = nil, username: String, pw_hash: String, email: String, next_card_index: Int = 1, next_collection_index: Int = 1, next_deck_index: Int = 1, next_deck_folder_index: Int = 1) {
        self.id = id
        self.username = username
        self.pw_hash = pw_hash
        self.email = email
        self.next_card_index = next_card_index
        self.next_collection_index = next_collection_index
        self.next_deck_index = next_deck_index
        self.next_deck_folder_index = next_deck_folder_index
    }

    final class Public: Codable {
        var id: Int?
        var username: String

        init(id: Int? = nil, username: String) {
            self.id = id
            self.username = username
        }
    }
}

extension User: Content {}
extension User.Public: Content {}
extension User: Parameter {}

extension User {
    func toPublic() -> User.Public {
        return User.Public(id: id, username: username)
    }
}

extension Future where T: User {
    func toPublic() -> Future<User.Public> {
        return map(to: User.Public.self) { user in
            return user.toPublic()
        }
    }
}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \.username
    }

    static var passwordKey: WritableKeyPath<User, String> {
        return \.pw_hash
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = UserToken
}

struct CreateUser: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(User.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.username, type: .varchar(32))
            builder.field(for: \.pw_hash, type: .binary(32))
            builder.field(for: \.email, type: .varchar(320))
            builder.field(for: \.next_card_index)
            builder.field(for: \.next_collection_index)
            builder.field(for: \.next_deck_index)
            builder.field(for: \.next_deck_folder_index)

            builder.unique(on: \.username)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(User.self, on: conn)
    }
}
