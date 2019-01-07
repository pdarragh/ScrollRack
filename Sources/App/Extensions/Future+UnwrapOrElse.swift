//
//  Future+UnwrapOrElse.swift
//  App
//
//  Created by Pierce Darragh on 1/6/19.
//

import Vapor

public extension Future where Expectation: OptionalType {
    public func unwrapOrElse(_ callback: @escaping () throws -> Future<Expectation.WrappedType>) -> Future<Expectation.WrappedType> {
        return map(to: Bool.self) { optional in
            guard let _ = optional.wrapped else {
                return false
            }
            return true
        }.flatMap { canUnwrap in
            if canUnwrap {
                return self.map(to: Expectation.WrappedType.self) { optional in
                    return optional.wrapped!
                }
            } else {
                return try callback()
            }
        }
    }
}
