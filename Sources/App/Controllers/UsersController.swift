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

    static func index(_ req: Request) throws -> Future<[SafeUserResponse]> {
        return User.query(on: req).decode(data: SafeUserResponse.self).all()
    }

    static func create(_ req: Request, newUserRequest user: CreateUserRequest) throws -> Future<SafeUserResponse> {
        return User.query(on: req).filter(\.username == user.username).first().flatMap { existingUser in
            // Ensure username is not already in use.
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with the given username already exists.")
            }
            // Ensure passwords matched.
            guard user.password == user.passwordVerification else {
                throw Abort(.badRequest, reason: "Given passwords did not match.")
            }
            // Generate BCrypt hash for password.
            let passwordHash = try BCrypt.hash(user.password)
            // Create user, default collection, and default deck folder.
            return User(id: nil, username: user.username, passwordHash: passwordHash, email: user.email).save(on: req).flatMap { newUser in
                return try UserCollectionsController.createCollectionForUser(newUser, withName: "Default Collection", on: req).flatMap { _ in
                    return try UserDeckFoldersController.createDeckFolderForUser(newUser, withName: "Default Deck Folder", on: req).map { _ in
                        return newUser.toSafeResponse()
                    }
                }
            }
        }
    }

    static func find(_ req: Request) throws -> Future<SafeUserResponse> {
        let (user, _) = try ControllersCommon.extractUserAndID(req)
        return user.toSafeResponse()
    }

    static func findUnsafe(_ req: Request) throws -> User {
        return try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthenticated)
    }

    static func verifyUserIDExists(_ id: Int, withRequest req: Request) throws -> Future<User> {
        return User.find(id, on: req).unwrap(or: Abort(.notFound, reason: "No user with ID: \(id)."))
    }

    static func update(_ req: Request, updatedUserRequest: UpdateUserRequest) throws -> Future<SafeUserResponse> {
        let user = try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthenticated)

        if let newUsername = updatedUserRequest.new_username {
            _ = User.query(on: req).filter(\.username == newUsername).first().map { existingUser in
                guard existingUser == nil else {
                    throw Abort(.badRequest, reason: "A user with the given username already exists.")
                }
                user.username = newUsername
            }
        }

        if let newPassword = updatedUserRequest.new_password {
            guard newPassword == updatedUserRequest.new_password_verification else {
                throw Abort(.badRequest, reason: "Given passwords did not match.")
            }
            user.passwordHash = try BCrypt.hash(newPassword)
        }

        return user.save(on: req).toSafeResponse()
    }
}

struct CreateUserRequest: Content {
    var username: String
    var password: String
    var passwordVerification: String
    var email: String
}

struct UpdateUserRequest: Content {
    var new_username: String?
    var new_password: String?
    var new_password_verification: String?
}
