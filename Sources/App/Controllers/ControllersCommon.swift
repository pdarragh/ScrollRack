//
//  ControllersCommon.swift
//  App
//
//  Created by Pierce Darragh on 1/9/19.
//

import Fluent
import Vapor

final class ControllersCommon {
    static func extractUserAndID(_ req: Request) throws -> (Future<User>, User.ID) {
        let userID = try req.parameters.next(Int.self)
        return (try UsersController.verifyUserIDExists(userID, withRequest: req), userID)
    }

    static func extractUserID(_ req: Request) throws -> User.ID {
        let (_, userID) = try extractUserAndID(req)
        return userID
    }

    static func extractAuthenticatedUser(_ req: Request, failureReason: FailureReason?) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        let userID = try extractUserID(req)
        guard user.id == userID else {
            throw Abort(.unauthorized, reason: failureReason?.rawValue)
        }
        return user
    }

    static func extractUserIDAndElementIndex(_ req: Request) throws -> (User.ID, Int) {
        let userID = try extractUserID(req)
        let elementIndex = try req.parameters.next(Int.self)
        return (userID, elementIndex)
    }

    static func extractAuthenticatedUserIDAndElementIndex(_ req: Request, failureReason: FailureReason?) throws -> (Int, Int) {
        let user = try extractAuthenticatedUser(req, failureReason: failureReason)
        let elementIndex = try req.parameters.next(Int.self)
        return (user.id!, elementIndex)
    }
}

enum FailureReason: String {
    case notAuthorized = "Cannot modify assets of others users."
    case notAuthenticated = "No user authenticated."
}
