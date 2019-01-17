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

        return Deck.query(on: req).filter(\.userID == userID).all()
    }

    static func create(_ req: Request, newDeckRequest: CreateDeckRequest) throws -> Future<Deck> {
        let user = try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthorized)

        let index = user.nextDeckIndex
        user.nextDeckIndex += 1

        return user.save(on: req).flatMap { _ in
            return Deck(id: nil, name: newDeckRequest.name, userID: user.id!, userIndex: index).save(on: req)
        }
    }

    static func find(_ req: Request, userID: Int, deckIndex: Int) throws -> Future<Deck> {
        return Deck.query(on: req).filter(\.userID == userID).filter(\.userIndex == deckIndex).first().unwrap(or: Abort(.badRequest, reason: "No deck with user index \(deckIndex) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<Deck> {
        let (userID, deckIndex) = try ControllersCommon.extractUserIDAndElementIndex(req)

        return try find(req, userID: userID, deckIndex: deckIndex)
    }

    static func update(_ req: Request, updatedDeckRequest updatedDeck: UpdateDeckRequest) throws -> Future<Deck> {
        let (userID, deckIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, deckIndex: deckIndex).flatMap { deck in
            deck.name = updatedDeck.new_name
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
    var new_name: String
}
