//
//  UserCardsController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserCardsController {
    static func index(_ req: Request) throws -> Future<[Card]> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return Card.query(on: req).filter(\.user_id == userId).all()
        }
    }

    static func create(_ req: Request, newCard: Card) throws -> Future<Card> {
        let userId = try req.parameters.next(Int.self)

        return try UsersController.verifyUserById(userId, withRequest: req).flatMap { _ in
            return newCard.save(on: req)
        }
    }
}
