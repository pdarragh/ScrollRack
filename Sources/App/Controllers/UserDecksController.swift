//
//  UserDecksController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserDecksController {
    func index(_ req: Request) throws -> Future<[Deck]> {
        let userId = try req.parameters.next(Int.self)
        return Deck.query(on: req).filter(\.user_id == userId).all()
    }
}
