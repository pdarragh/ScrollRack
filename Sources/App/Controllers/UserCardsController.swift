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

        return Card.query(on: req).filter(\.userID == userID).all()
    }

    static func create(_ req: Request, newCardRequest: CreateCardRequest) throws -> Future<Card> {
        let user = try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthorized)

        let index = user.nextCardIndex
        user.nextCardIndex += 1

        return user.save(on: req).flatMap { _ in
            return Card(id: nil, owned: true, oracleID: newCardRequest.oracle_id, userID: user.id!, userIndex: index, scryfallID: newCardRequest.scryfall_id, condition: newCardRequest.condition, foil: newCardRequest.foil, extraInfo: newCardRequest.notes).save(on: req)
        }
    }

    static func find(_ req: Request, userID: Int, cardIndex: Int) throws -> Future<Card> {
        return Card.query(on: req).filter(\.userID == userID).filter(\.userIndex == cardIndex).first().unwrap(or: Abort(.badRequest, reason: "No card with user index \(cardIndex) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<Card> {
        let (userID, cardIndex) = try ControllersCommon.extractUserIDAndElementIndex(req)

        return try find(req, userID: userID, cardIndex: cardIndex)
    }

    static func update(_ req: Request, updatedCardRequest updatedCard: UpdateCardRequest) throws -> Future<Card> {
        let (userID, cardIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, cardIndex: cardIndex).flatMap { card in
            card.scryfallID = updatedCard.scryfall_id ?? card.scryfallID
            card.condition = updatedCard.condition ?? card.condition
            card.foil = updatedCard.foil ?? card.foil
            card.extraInfo = updatedCard.notes ?? card.extraInfo
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
    var oracle_id: UUID
    var scryfall_id: UUID?
    var condition: Int?
    var foil: Bool?
    var notes: String?
}

struct UpdateCardRequest: Content {
    var scryfall_id: UUID?
    var condition: Int?
    var foil: Bool?
    var notes: String?
}
