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
        let userID = try ControllersCommon.extractUserID(req)

        return Card.query(on: req).filter(\.user_id == userID).all()
    }

    static func create(_ req: Request, newCardRequest: CreateCardRequest) throws -> Future<Card> {
        let user = try ControllersCommon.extractUserWithAuthentication(req, failureReason: .notAuthorized)

        let index = user.next_card_index
        user.next_card_index += 1

        return user.save(on: req).flatMap { _ in
            return Card(id: nil, scryfall_id: newCardRequest.scryfall_id, play_condition: newCardRequest.play_condition, foil: newCardRequest.foil, added: Date(), modified: Date(), user_id: user.id!, user_index: index).save(on: req)
        }
    }

    private static func find(_ req: Request, userID: Int, cardID: Int) throws -> Future<Card> {
        return Card.query(on: req).filter(\.user_id == userID).filter(\.user_index == cardID).first().unwrap(or: Abort(.badRequest, reason: "No card with ID \(cardID) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<Card> {
        let (userID, cardID) = try ControllersCommon.extractUserIDAndElementID(req)

        return try find(req, userID: userID, cardID: cardID)
    }

    static func update(_ req: Request, updatedCardRequest updatedCard: UpdateCardRequest) throws -> Future<Card> {
        let (userID, cardID) = try ControllersCommon.extractUserIDAndElementIDWithAuthentication(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, cardID: cardID).flatMap { card in
            card.play_condition = updatedCard.play_condition ?? card.play_condition
            card.foil = updatedCard.foil ?? card.foil
            card.modified = Date()
            return card.update(on: req, originalID: card.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        _ = try req.requireAuthenticated(User.self)

        return try find(req).flatMap { card in
            return card.delete(on: req).map {
                return "Deleted card."
            }
        }
    }
}

struct CreateCardRequest: Content {
    var scryfall_id: UUID
    var play_condition: Int
    var foil: Bool
}

struct UpdateCardRequest: Content {
    var play_condition: Int?
    var foil: Bool?
}
