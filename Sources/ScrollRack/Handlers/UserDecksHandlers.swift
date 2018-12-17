//
//  UserDecksHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func getUserDecksHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict: JSON = [
        "user_id": "\(user_id)",
        "decks": [],
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func postUserDecksHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func getUserDeckHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let deck_id = extractUrlVariable("deck_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "deck_id": "\(deck_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func putUserDeckHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let deck_id = extractUrlVariable("deck_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "deck_id": "\(deck_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func deleteUserDeckHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let deck_id = extractUrlVariable("deck_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "deck_id": "\(deck_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUserDecksRoutes() -> Routes {
    var routes = Routes(baseUri: "/users/{user_id}")
    routes.add(method: .get, uri: "/decks", handler: getUserDecksHandler)
    routes.add(method: .post, uri: "/decks", handler: postUserDecksHandler)
    routes.add(method: .get, uri: "/decks/{deck_id}", handler: getUserDeckHandler)
    routes.add(method: .put, uri: "/decks/{deck_id}", handler: putUserDeckHandler)
    routes.add(method: .delete, uri: "/decks/{deck_id}", handler: deleteUserDeckHandler)
    return routes
}
