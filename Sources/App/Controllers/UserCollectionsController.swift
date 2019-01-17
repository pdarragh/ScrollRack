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
        let userID = try ControllersCommon.extractUserID(req)

        return Collection.query(on: req).filter(\.userID == userID).all()
    }

    static func createCollectionForUser(_ user: User, withName name: String, on req: Request) throws -> Future<Collection> {
        let index = user.nextCollectionIndex
        user.nextCollectionIndex += 1

        return user.save(on: req).flatMap { _ in
            return Collection(id: nil, name: name, userID: user.id!, userIndex: index).save(on: req)
        }
    }

    static func create(_ req: Request, newCollectionRequest: CreateCollectionRequest) throws -> Future<Collection> {
        let user = try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthorized)

        return try createCollectionForUser(user, withName: newCollectionRequest.name, on: req)
    }

    private static func find(_ req: Request, userID: Int, collectionIndex: Int) throws -> Future<Collection> {
        return Collection.query(on: req).filter(\.userID == userID).filter(\.userIndex == collectionIndex).first().unwrap(or: Abort(.badRequest, reason: "No collection with user index \(collectionIndex) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<CollectionWithCardsResponse> {
        let (userID, collectionIndex) = try ControllersCommon.extractUserIDAndElementIndex(req)

        return try find(req, userID: userID, collectionIndex: collectionIndex).toResponseWithCards(on: req)
    }

    static func update(_ req: Request, updatedCollectionRequest updatedCollection: UpdateCollectionRequest) throws -> Future<Collection> {
        let (userID, collectionIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, collectionIndex: collectionIndex).flatMap { collection in
            if let newName = updatedCollection.new_name {
                collection.name = newName
            }

            if let newCardIndex = updatedCollection.new_card_index {
                _ = try UserCardsController.find(req, userID: userID, cardIndex: newCardIndex).flatMap { card in
                    CardsToCollectionsPivot(cardID: card.id!, collectionID: collection.id!).save(on: req)
                }
            }

            return collection.update(on: req, originalID: collection.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        let (userID, collectionIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, collectionIndex: collectionIndex).flatMap { collection in
            return collection.delete(on: req).map {
                return "Deleted collection."
            }
        }
    }
}

struct CreateCollectionRequest: Content {
    var name: String
}

struct UpdateCollectionRequest: Content {
    var new_name: String?
    var new_card_index: Int?
}
