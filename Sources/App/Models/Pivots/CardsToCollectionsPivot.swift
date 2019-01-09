//
//  CardsToCollectionsPivot.swift
//  App
//
//  Created by Pierce Darragh on 1/9/19.
//

import FluentMySQL
import Vapor

final class CardsToCollectionsPivot: MySQLPivot {
    static let entity = "cards_TO_collections"

    typealias Left = Card
    typealias Right = Collection

    static var leftIDKey: LeftIDKey = \.card_id
    static var rightIDKey: RightIDKey = \.collection_id

    var id: Int?
    var card_id: Int
    var collection_id: Int

    init(card_id: Int, collection_id: Int) {
        self.card_id = card_id
        self.collection_id = collection_id
    }
}

extension CardsToCollectionsPivot: MySQLMigration {}
