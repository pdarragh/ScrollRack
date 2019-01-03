//
//  UserToken.swift
//  App
//
//  Created by Pierce Darragh on 1/2/19.
//

import Authentication
import FluentMySQL
import Vapor

final class UserToken: MySQLModel {
    static let entity = "user_tokens"

    var id: Int?
    var string: String
    var user_id: User.ID
    var expires_at: Date?

    init(id: Int? = nil, string: String, user_id: User.ID) {
        self.id = id
        self.string = string
        self.user_id = user_id
        self.expires_at = Date.init(timeInterval: 60 * 60 * 5, since: .init())
    }

    static func create(userID: User.ID) throws -> UserToken {
        let string = try CryptoRandom().generateData(count: 16).base64EncodedString()
        return .init(string: string, user_id: userID)
    }
}

extension UserToken: Content {}
extension UserToken: Parameter {}

extension UserToken {
    var user: Parent<UserToken, User> {
        return parent(\.user_id)
    }
}

extension UserToken: Token {
    typealias UserType = User

    static var tokenKey: WritableKeyPath<UserToken, String> {
        return \.string
    }

    static var userIDKey: WritableKeyPath<UserToken, User.ID> {
        return \.user_id
    }
}

struct CreateUserToken: MySQLMigration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.create(UserToken.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.string)
            builder.field(for: \.user_id)
            builder.field(for: \.expires_at)

            builder.reference(from: \.user_id, to: \User.id)
        }
    }

    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return MySQLDatabase.delete(UserToken.self, on: conn)
    }
}
