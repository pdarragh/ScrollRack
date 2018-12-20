//
//  UserCardsController.swift
//  App
//
//  Created by Pierce Darragh on 12/18/18.
//

import Fluent
import Vapor

final class UserCardsController {
    func index(_ req: Request) throws -> Future<[Card]> {
        let userId = try req.parameters.next(Int.self)
        return Card.query(on: req).filter(\.user_id == userId).all()
    }

    func create(_ req: Request) throws -> Future<Card> {
        return try req.content.decode(Card.self).flatMap { card in
            return card.save(on: req)
        }
    }
}
