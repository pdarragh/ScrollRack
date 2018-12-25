//
//  UsersController.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import Fluent
import Vapor

final class UsersController {
    static func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    static func create(_ req: Request, newUser user: User) throws -> Future<User> {
        return User.query(on: req).filter(\.username == user.username).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with the given username already exists.")
            }

            let persistedUser = User(id: nil, username: user.username, pw_hash: user.pw_hash, pw_salt: user.pw_salt, email: user.email)
            return persistedUser.save(on: req)
        }
    }

    static func find(_ req: Request) throws -> Future<User> {
        let userId = try req.parameters.next(Int.self)
        return try UsersController.verifyUserById(userId, withRequest: req)
    }

    static func verifyUserById(_ id: Int, withRequest req: Request) throws -> Future<User> {
        return User.find(id, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(id)."))
    }
}
