//
//  UsersCollectionsHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func getUserCollectionsHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    guard let user_id = request.urlVariables["id"] else {
        fatalError("No user ID given.")
    }

    let responseDict: JSON = [
        "user_id": "\(user_id)",
        "collections": [],
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUserCollectionsRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/users/{id}/collections", handler: getUserCollectionsHandler)
    return routes
}
