//
//  SafeUserResponse.swift
//  App
//
//  Created by Pierce Darragh on 1/10/19.
//

import Vapor

final class SafeUserResponse: Content {
    var id: Int?
    var username: String

    init(id: Int? = nil, username: String) {
        self.id = id
        self.username = username
    }
}

extension User {
    func toSafeResponse() -> SafeUserResponse {
        return SafeUserResponse(id: id, username: username)
    }
}

extension Future where T: User {
    func toSafeResponse() -> Future<SafeUserResponse> {
        return map(to: SafeUserResponse.self) { user in
            return user.toSafeResponse()
        }
    }
}
