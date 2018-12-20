//
//  UsersController.swift
//  App
//
//  Created by Pierce Darragh on 12/17/18.
//

import Fluent
import Vapor

final class UsersController {
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func find(_ req: Request) throws -> Future<User> {
        let userId = try req.parameters.next(Int.self)
        return User.find(userId, on: req).unwrap(or: Abort(.notFound))
    }
}