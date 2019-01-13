//
//  Model+Siblings.swift
//  App
//
//  Created by Pierce Darragh on 1/12/19.
//

import Fluent

extension Model {
    public func childrenSiblings<Through>(
        through: Through.Type = Through.self
    ) -> Siblings<Self, Self, Through>
        where Through.Left == Self, Through.Right == Self
    {
        return siblings(Through.leftIDKey, Through.rightIDKey)
    }

    public func parentSiblings<Through>(
        through: Through.Type = Through.self
    ) -> Siblings<Self, Self, Through>
        where Through.Left == Self, Through.Right == Self
    {
        return siblings(Through.rightIDKey, Through.leftIDKey)
    }
}
