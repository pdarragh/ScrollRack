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

    static func create(_ req: Request, newUser user: User) throws -> Future<User.Public> {
        return User.query(on: req).filter(\.username == user.username).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with the given username already exists.")
            }

            user.pw_hash = try BCrypt.hash(user.pw_hash)
            user.pw_salt = try BCrypt.hash(user.pw_salt)

            let persistedUser = User(id: nil, username: user.username, pw_hash: user.pw_hash, pw_salt: user.pw_salt, email: user.email)
            return persistedUser.save(on: req).toPublic()
        }
    }

    static func find(_ req: Request) throws -> Future<User.Public> {
        let userId = try req.parameters.next(Int.self)
        return try UsersController.verifyUserById(userId, withRequest: req).toPublic()
    }

    static func findFull(_ req: Request) throws -> Future<User> {
        let user = try req.requireAuthenticated(User.self)
        guard let userID = user.id else {
            throw Abort(.badRequest, reason: "No user authenticated.")
        }
        return User.find(userID, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(userID)."))
    }

    static func verifyUserById(_ id: Int, withRequest req: Request) throws -> Future<User> {
        return User.find(id, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(id)."))
    }
}
