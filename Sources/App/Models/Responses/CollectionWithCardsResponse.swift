//
//  CollectionWithCardsResponse.swift
//  App
//
//  Created by Pierce Darragh on 1/10/19.
//

import Vapor

final class CollectionWithCardsResponse: Content {
    var name: String
    var user_index: Int
    var cards: [Card]

    init(name: String, user_index: Int, cards: [Card]) {
        self.name = name
        self.user_index = user_index
        self.cards = cards
    }
}

extension Future where T: Collection {
    func toResponseWithCards(on req: Request) -> Future<CollectionWithCardsResponse> {
        return flatMap(to: CollectionWithCardsResponse.self) { collection in
            try collection.cards.query(on: req).all().map { cards in
                return CollectionWithCardsResponse(name: collection.name, user_index: collection.user_index, cards: cards)
            }
        }
    }
}
