//
//  UserIndicesController.swift
//  App
//
//  Created by Pierce Darragh on 1/5/19.
//

import Fluent
import Vapor

final class UserIndicesController {
    static func createCardIndex(_ req: Request, forUser userID: Int, withNextIndex nextIndex: Int = 1) throws -> Future<UserCardIndex> {
        return UserCardIndex(id: nil, user_id: userID, next_index: nextIndex).save(on: req)
    }

    static func findCardIndex(_ req: Request, forUser userID: Int) throws -> Future<UserCardIndex?> {
        return UserCardIndex.query(on: req).filter(\.user_id == userID).first()
    }

    static func findOrCreateCardIndex(_ req: Request, forUser userID: Int) throws -> Future<UserCardIndex> {
        return try findCardIndex(req, forUser: userID).unwrapOrElse { () in
            return try createCardIndex(req, forUser: userID)
        }
    }

    static func incrementCardIndex(_ cardIndex: UserCardIndex, on req: Request) throws -> Future<UserCardIndex> {
        return UserCardIndex(id: cardIndex.id, user_id: cardIndex.user_id, next_index: cardIndex.next_index + 1).update(on: req, originalID: cardIndex.id)
    }
}
