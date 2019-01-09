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
        let userID = try ControllersCommon.extractUserID(req)

        return Deck.query(on: req).filter(\.user_id == userID).all()
    }

    static func create(_ req: Request, newDeckRequest: CreateDeckRequest) throws -> Future<Deck> {
        let user = try ControllersCommon.extractUserWithAuthentication(req, failureReason: .notAuthorized)

        let index = user.next_deck_index
        user.next_deck_index += 1

        return user.save(on: req).flatMap { _ in
            return Deck(id: nil, name: newDeckRequest.name, user_id: user.id!, user_index: index).save(on: req)
        }
    }

    static func find(_ req: Request, userID: Int, deckID: Int) throws -> Future<Deck> {
        return Deck.query(on: req).filter(\.user_id == userID).filter(\.user_index == deckID).first().unwrap(or: Abort(.badRequest, reason: "No deck with ID \(deckID) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<Deck> {
        let (userID, deckID) = try ControllersCommon.extractUserIDAndElementID(req)

        return try find(req, userID: userID, deckID: deckID)
    }

    static func update(_ req: Request, updatedDeckRequest updatedDeck: UpdateDeckRequest) throws -> Future<Deck> {
        let (userID, deckID) = try ControllersCommon.extractUserIDAndElementIDWithAuthentication(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, deckID: deckID).flatMap { deck in
            deck.name = updatedDeck.name
            return deck.update(on: req, originalID: deck.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        _ = try req.requireAuthenticated(User.self)

        return try find(req).flatMap { deck in
            return deck.delete(on: req).map {
                return "Deleted deck."
            }
        }
    }
}

struct CreateDeckRequest: Content {
    var name: String
}

struct UpdateDeckRequest: Content {
    var name: String
}
