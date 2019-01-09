//
//  ControllersCommon.swift
//  App
//
//  Created by Pierce Darragh on 1/9/19.
//

import Fluent
import Vapor

final class ControllersCommon {
    static func extractUserID(_ req: Request) throws -> Int {
        let userID = try req.parameters.next(Int.self)
        _ = try UsersController.verifyUserIDExists(userID, withRequest: req)
        return userID
    }

    static func extractUserWithAuthentication(_ req: Request, failureReason: FailureReason?) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        let userID = try extractUserID(req)
        guard user.id == userID else {
            throw Abort(.unauthorized, reason: failureReason?.rawValue)
        }
        return user
    }

    static func extractUserIDAndElementID(_ req: Request) throws -> (Int, Int) {
        let userID = try extractUserID(req)
        let elementID = try req.parameters.next(Int.self)
        return (userID, elementID)
    }

    static func extractUserIDAndElementIDWithAuthentication(_ req: Request, failureReason: FailureReason?) throws -> (Int, Int) {
        let user = try extractUserWithAuthentication(req, failureReason: failureReason)
        let elementID = try req.parameters.next(Int.self)
        return (user.id!, elementID)
    }
}

enum FailureReason: String {
    case notAuthorized = "Cannot modify assets of others users."
}
