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
    var pw_salt: String
    var email: String

    init(id: Int? = nil, username: String, pw_hash: String, pw_salt: String, email: String) {
        self.id = id
        self.username = username
        self.pw_hash = pw_hash
        self.pw_salt = pw_salt
        self.email = email
    }
}

extension User: Content {}
extension User: Parameter {}
extension User: SessionAuthenticatable {}

struct CreateUser: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(User.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.username, type: .varchar(32))
            builder.field(for: \.pw_hash, type: .binary(32))
            builder.field(for: \.pw_salt, type: .binary(32))
            builder.field(for: \.email, type: .varchar(320))
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(User.self, on: conn)
    }
}
