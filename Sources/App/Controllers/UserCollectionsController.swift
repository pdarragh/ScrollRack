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
}

struct CreateCollectionRequest: Content {
    var name: String
}

struct UpdateCollectionRequest: Content {
    var name: String
}
