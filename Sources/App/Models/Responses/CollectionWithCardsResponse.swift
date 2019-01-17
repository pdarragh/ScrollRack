//
//  CollectionWithCardsResponse.swift
//  App
//
//  Created by Pierce Darragh on 1/10/19.
//

import Vapor

final class CollectionWithCardsResponse: Content {
    var name: String
    var userIndex: Int
    var cards: [Card]

    init(name: String, userIndex: Int, cards: [Card]) {
        self.name = name
        self.userIndex = userIndex
        self.cards = cards
    }
}

extension Future where T: Collection {
    func toResponseWithCards(on req: Request) -> Future<CollectionWithCardsResponse> {
        return flatMap(to: CollectionWithCardsResponse.self) { collection in
            try collection.cards.query(on: req).all().map { cards in
                return CollectionWithCardsResponse(name: collection.name, userIndex: collection.userIndex, cards: cards)
            }
        }
    }
}
