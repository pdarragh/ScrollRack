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

        return Collection.query(on: req).filter(\.user_id == userID).all()
    }

    static func create(_ req: Request, newCollectionRequest: CreateCollectionRequest) throws -> Future<Collection> {
        let user = try ControllersCommon.extractUserWithAuthentication(req, failureReason: .notAuthorized)

        let index = user.next_collection_index
        user.next_collection_index += 1

        return user.save(on: req).flatMap { _ in
            return Collection(id: nil, name: newCollectionRequest.name, user_id: user.id!, user_index: index).save(on: req)
        }
    }

    private static func find(_ req: Request, userID: Int, collectionID: Int) throws -> Future<Collection> {
        return Collection.query(on: req).filter(\.user_id == userID).filter(\.user_index == collectionID).first().unwrap(or: Abort(.badRequest, reason: "No collection with ID \(collectionID) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<Collection> {
        let (userID, collectionID) = try ControllersCommon.extractUserIDAndElementID(req)

        return try find(req, userID: userID, collectionID: collectionID)
    }

    static func update(_ req: Request, updatedCollectionRequest updatedCollection: UpdateCollectionRequest) throws -> Future<Collection> {
        let (userID, collectionID) = try ControllersCommon.extractUserIDAndElementIDWithAuthentication(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, collectionID: collectionID).flatMap { collection in
            collection.name = updatedCollection.name
            return collection.update(on: req, originalID: collection.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        _ = try req.requireAuthenticated(User.self)

        return try find(req).flatMap { collection in
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
    var name: String
}
