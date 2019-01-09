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
}
