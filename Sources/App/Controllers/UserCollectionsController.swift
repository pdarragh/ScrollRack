//
//  UserCollectionsController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserCollectionsController {
    func index(_ req: Request) throws -> Future<[Collection]> {
        let userId = try req.parameters.next(Int.self)
        return Collection.query(on: req).filter(\.user_id == userId).all()
    }
}