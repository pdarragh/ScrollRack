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
        return req.withPooledConnection(to: .mysql) { conn in
            return Deck.query(on: conn).filter(\.user_id == userId).all()
        }
    }
}
