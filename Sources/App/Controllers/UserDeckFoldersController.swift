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
        let userID = try ControllersCommon.extractUserID(req)

        return DeckFolder.query(on: req).filter(\.user_id == userID).all()
    }

    static func create(_ req: Request, newDeckFolderRequest: CreateDeckFolderRequest) throws -> Future<DeckFolder> {
        let user = try ControllersCommon.extractUserWithAuthentication(req, failureReason: .notAuthorized)

        let index = user.next_deck_folder_index
        user.next_deck_folder_index += 1

        return user.save(on: req).flatMap { _ in
            return DeckFolder(id: nil, name: newDeckFolderRequest.name, user_id: user.id!, user_index: index).save(on: req)
        }
    }

    private static func find(_ req: Request, userID: Int, deckFolderID: Int) throws -> Future<DeckFolder> {
        return DeckFolder.query(on: req).filter(\.user_id == userID).filter(\.user_index == deckFolderID).first().unwrap(or: Abort(.badRequest, reason: "No deck folder with ID \(deckFolderID) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<DeckFolder> {
        let (userID, deckFolderID) = try ControllersCommon.extractUserIDAndElementID(req)

        return try find(req, userID: userID, deckFolderID: deckFolderID)
    }

    static func update(_ req: Request, updatedDeckFolderRequest updatedDeckFolder: UpdateDeckFolderRequest) throws -> Future<DeckFolder> {
        let (userID, deckFolderID) = try ControllersCommon.extractUserIDAndElementIDWithAuthentication(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, deckFolderID: deckFolderID).flatMap { deckFolder in
            deckFolder.name = updatedDeckFolder.name
            return deckFolder.update(on: req, originalID: deckFolder.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        _ = try req.requireAuthenticated(User.self)

        return try find(req).flatMap { deckFolder in
            return deckFolder.delete(on: req).map {
                return "Deleted deck folder."
            }
        }
    }
}

struct CreateDeckFolderRequest: Content {
    var name: String
}

struct UpdateDeckFolderRequest: Content {
    var name: String
}
