//
//  UsersController.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import Crypto
import Fluent
import Vapor

final class UsersController {
    static func login(_ req: Request) throws -> Future<UserToken> {
        let user = try req.requireAuthenticated(User.self)
        let token = try UserToken.create(userID: user.requireID())
        return token.save(on: req)
    }

    static func index(_ req: Request) throws -> Future<[User.Public]> {
        return User.query(on: req).decode(data: User.Public.self).all()
    }

    static func create(_ req: Request, newUserRequest user: CreateUserRequest) throws -> Future<User.Public> {
        return User.query(on: req).filter(\.username == user.username).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with the given username already exists.")
            }

            guard user.password == user.passwordVerification else {
                throw Abort(.badRequest, reason: "Given passwords did not match.")
            }

            let pw_hash = try BCrypt.hash(user.password)

            return User(id: nil, username: user.username, pw_hash: pw_hash, email: user.email).save(on: req).toPublic()
        }
    }

    static func find(_ req: Request) throws -> Future<User.Public> {
        let userId = try req.parameters.next(Int.self)
        return try UsersController.verifyUserIDExists(userId, withRequest: req).toPublic()
    }

    static func findFull(_ req: Request) throws -> Future<User> {
        let user = try req.requireAuthenticated(User.self)
        guard let userID = user.id else {
            throw Abort(.badRequest, reason: "No user authenticated.")
        }
        return User.find(userID, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(userID)."))
    }

    static func verifyUserIDExists(_ id: Int, withRequest req: Request) throws -> Future<User> {
        return User.find(id, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(id)."))
    }
}

struct CreateUserRequest: Content {
    var username: String
    var password: String
    var passwordVerification: String
    var email: String
}
