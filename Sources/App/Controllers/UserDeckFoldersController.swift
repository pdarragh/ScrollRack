//
//  UserDeckFoldersController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserDeckFoldersController {
    static func index(_ req: Request) throws -> Future<[DeckFolder]> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return DeckFolder.query(on: req).filter(\.user_id == userId).all()
        }
    }

    static func create(_ req: Request, newDeckFolder: DeckFolder) throws -> Future<DeckFolder> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return newDeckFolder.save(on: req)
        }
    }
}
