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
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func putUserHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func deleteUserHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUsersRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/users", handler: getUsersHandler)
    routes.add(method: .post, uri: "/users", handler: postUsersHandler)
    routes.add(method: .get, uri: "/users/{user_id}", handler: getUserHandler)
    routes.add(method: .put, uri: "/users/{user_id}", handler: putUserHandler)
    routes.add(method: .delete, uri: "/users/{user_id}", handler: deleteUserHandler)
    return routes
}
