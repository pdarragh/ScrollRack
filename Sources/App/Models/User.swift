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
    var passwordHash: String
    var email: String
    var nextCardIndex: Int
    var nextCollectionIndex: Int
    var nextDeckIndex: Int
    var nextDeckFolderIndex: Int

    init(id: Int? = nil, username: String, passwordHash: String, email: String, nextCardIndex: Int = 1, nextCollectionIndex: Int = 1, nextDeckIndex: Int = 1, nextDeckFolderIndex: Int = 1) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
        self.email = email
        self.nextCardIndex = nextCardIndex
        self.nextCollectionIndex = nextCollectionIndex
        self.nextDeckIndex = nextDeckIndex
        self.nextDeckFolderIndex = nextDeckFolderIndex
    }
}

extension User: Content {}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \.username
    }

    static var passwordKey: WritableKeyPath<User, String> {
        return \.passwordHash
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
            builder.field(for: \.passwordHash, type: .binary(60))
            builder.field(for: \.email, type: .varchar(320))
            builder.field(for: \.nextCardIndex)
            builder.field(for: \.nextCollectionIndex)
            builder.field(for: \.nextDeckIndex)
            builder.field(for: \.nextDeckFolderIndex)

            builder.unique(on: \.username)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(User.self, on: conn)
    }
}
