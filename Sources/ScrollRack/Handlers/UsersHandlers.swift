//
//  UserHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func getUsersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let responseDict = [
        "users": [],
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func postUsersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let responseDict = [
        "user_id": "null",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func getUserHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    guard let user_id = request.urlVariables["id"] else {
        fatalError("No user ID given.")
    }

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUsersRoutes() -> Routes {
    var usersRoutes = Routes()
    usersRoutes.add(method: .get, uri: "/users", handler: getUsersHandler)
    usersRoutes.add(method: .post, uri: "/users", handler: postUsersHandler)
    usersRoutes.add(method: .get, uri: "/users/{id}", handler: getUserHandler)
    return usersRoutes
}
