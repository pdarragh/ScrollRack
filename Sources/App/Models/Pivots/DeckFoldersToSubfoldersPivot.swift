//
//  DeckFoldersToSubfoldersPivot.swift
//  App
//
//  Created by Pierce Darragh on 1/9/19.
//

import FluentMySQL
import Vapor

final class DeckFoldersToSubfoldersPivot: MySQLPivot {
    static let entity = "deck_folders_TO_subfolders"

    typealias Left = DeckFolder
    typealias Right = DeckFolder

    static var leftIDKey: LeftIDKey = \.parentFolderID
    static var rightIDKey: RightIDKey = \.childFolderID

    var id: Int?
    var parentFolderID: Int
    var childFolderID: Int

    init(parentFolderID: Int, childFolderID: Int) {
        self.parentFolderID = parentFolderID
        self.childFolderID = childFolderID
    }
}

extension DeckFoldersToSubfoldersPivot: MySQLMigration {}
