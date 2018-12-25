//
//  UserCollectionsController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserCollectionsController {
    static func index(_ req: Request) throws -> Future<[Collection]> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return Collection.query(on: req).filter(\.user_id == userId).all()
        }
    }

    static func create(_ req: Request, newCollection: Collection) throws -> Future<Collection> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return newCollection.save(on: req)
        }
    }
}
