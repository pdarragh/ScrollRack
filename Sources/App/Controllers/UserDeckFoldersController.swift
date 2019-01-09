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
}
