//
//  UsersCollectionsHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func getUserCollectionsHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict: JSON = [
        "user_id": "\(user_id)",
        "collections": [],
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func postUserCollectionsHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func getUserCollectionHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let collection_id = extractUrlVariable("collection_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "collection_id": "\(collection_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func putUserCollectionHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let collection_id = extractUrlVariable("collection_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "collection_id": "\(collection_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func deleteUserCollectionHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let collection_id = extractUrlVariable("collection_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "collection_id": "\(collection_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUserCollectionsRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/users/{user_id}/collections", handler: getUserCollectionsHandler)
    routes.add(method: .post, uri: "/users/{user_id}/collections", handler: postUserCollectionsHandler)
    routes.add(method: .get, uri: "/users/{user_id}/collections/{collection_id}", handler: getUserCollectionHandler)
    routes.add(method: .put, uri: "/users/{user_id}/collections/{collection_id}", handler: putUserCollectionHandler)
    routes.add(method: .delete, uri: "/users/{user_id}/collections/{collection_id}", handler: deleteUserCollectionHandler)
    return routes
}
