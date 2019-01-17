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

    static var leftIDKey: LeftIDKey = \.cardID
    static var rightIDKey: RightIDKey = \.collectionID

    var id: Int?
    var cardID: Int
    var collectionID: Int

    init(cardID: Int, collectionID: Int) {
        self.cardID = cardID
        self.collectionID = collectionID
    }
}

extension CardsToCollectionsPivot: MySQLMigration {}
