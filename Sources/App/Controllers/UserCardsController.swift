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

    static func create(_ req: Request, newCardRequest: CreateCardRequest) throws -> Future<Card> {
        let user = try req.requireAuthenticated(User.self)
        let userID = try req.parameters.next(Int.self)

        guard user.id == userID else {
            throw Abort(.unauthorized, reason: "Cannot modify assets of another user.")
        }

        return try UserIndicesController.findOrCreateCardIndex(req, forUser: userID).flatMap { cardIndex in
            return try UserIndicesController.incrementCardIndex(cardIndex, on: req).flatMap { _ in
                return Card(id: nil, scryfall_id: newCardRequest.scryfall_id, play_condition: newCardRequest.play_condition, foil: newCardRequest.foil, added: Date(), modified: Date(), user_id: userID, user_index: cardIndex.next_index).save(on: req)
            }
        }
    }
}

struct CreateCardRequest: Content {
    var scryfall_id: UUID
    var play_condition: Int
    var foil: Bool
}
