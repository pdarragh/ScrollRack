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

    static func createDeckFolderForUser(_ user: User, withName name: String, on req: Request) throws -> Future<DeckFolder> {
        let index = user.next_deck_folder_index
        user.next_deck_folder_index += 1

        return user.save(on: req).flatMap { _ in
            return DeckFolder(id: nil, name: name, user_id: user.id!, user_index: index).save(on: req)
        }
    }

    static func create(_ req: Request, newDeckFolderRequest: CreateDeckFolderRequest) throws -> Future<DeckFolder> {
        let user = try ControllersCommon.extractAuthenticatedUser(req, failureReason: .notAuthorized)

        return try createDeckFolderForUser(user, withName: newDeckFolderRequest.name, on: req)
    }

    static func find(_ req: Request, userID: Int, deckFolderIndex: Int) throws -> Future<DeckFolder> {
        return DeckFolder.query(on: req).filter(\.user_id == userID).filter(\.user_index == deckFolderIndex).first().unwrap(or: Abort(.badRequest, reason: "No deck folder with user index \(deckFolderIndex) belonging to user with ID \(userID)."))
    }

    static func find(_ req: Request) throws -> Future<DeckFolderWithChildrenResponse> {
        let (userID, deckFolderIndex) = try ControllersCommon.extractUserIDAndElementIndex(req)

        return try find(req, userID: userID, deckFolderIndex: deckFolderIndex).toResponseWithChildren(on: req)
    }

    static func update(_ req: Request, updatedDeckFolderRequest updatedDeckFolder: UpdateDeckFolderRequest) throws -> Future<DeckFolder> {
        let (userID, deckFolderIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, deckFolderIndex: deckFolderIndex).flatMap { deckFolder in
            if let newName = updatedDeckFolder.new_name {
                deckFolder.name = newName
            }

            if let newDeckIndex = updatedDeckFolder.new_deck_index {
                _ = try UserDecksController.find(req, userID: userID, deckIndex: newDeckIndex).flatMap { deck in
                    DeckFoldersToDecksPivot(deck_folder_id: deckFolder.id!, deck_id: deck.id!).save(on: req)
                }
            }

            if let newChildFolderIndex = updatedDeckFolder.new_child_folder_index {
                _ = try find(req, userID: userID, deckFolderIndex: newChildFolderIndex).flatMap { childDeckFolder in
                    DeckFoldersToSubfoldersPivot(parent_folder_id: deckFolder.id!, child_folder_id: childDeckFolder.id!).save(on: req)
                }
            }

            return deckFolder.update(on: req, originalID: deckFolder.id)
        }
    }

    static func delete(_ req: Request) throws -> Future<String> {
        let (userID, deckFolderIndex) = try ControllersCommon.extractAuthenticatedUserIDAndElementIndex(req, failureReason: .notAuthorized)

        return try find(req, userID: userID, deckFolderIndex: deckFolderIndex).flatMap { deckFolder in
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
    var new_name: String?
    var new_deck_index: Int?
    var new_child_folder_index: Int?
}
