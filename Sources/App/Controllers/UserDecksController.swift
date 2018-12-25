//
//  UserDecksController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserDecksController {
    static func index(_ req: Request) throws -> Future<[Deck]> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return Deck.query(on: req).filter(\.user_id == userId).all()
        }
    }

    static func create(_ req: Request, newDeck: Deck) throws -> Future<Deck> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return newDeck.save(on: req)
        }
    }
}
