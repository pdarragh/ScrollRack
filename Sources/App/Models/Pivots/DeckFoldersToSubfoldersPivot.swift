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

    static var leftIDKey: LeftIDKey = \.parent_folder_id
    static var rightIDKey: RightIDKey = \.child_folder_id

    var id: Int?
    var parent_folder_id: Int
    var child_folder_id: Int

    init(parent_folder_id: Int, child_folder_id: Int) {
        self.parent_folder_id = parent_folder_id
        self.child_folder_id = child_folder_id
    }
}

extension DeckFoldersToSubfoldersPivot: MySQLMigration {}
