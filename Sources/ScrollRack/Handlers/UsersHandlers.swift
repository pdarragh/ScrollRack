//
//  UserHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func encode(_ json: [String: Any]) -> String {
    guard let responseString = try? json.jsonEncodedString() else {
        fatalError("Could not encode JSON dictionary.")
    }
    return responseString
}

private func makeJsonBody(fromDictionary dict: [String: Any], withResponse response: HTTPResponse) {
    response.setHeader(.contentType, value: "application/json")
    response.setBody(string: encode(dict))
    response.completed()
}

private func getUsersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let responseDict = [
        "users": [],
    ]

    makeJsonBody(fromDictionary: responseDict, withResponse: response)
}

private func postUsersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let responseDict = [
        "user_id": "null",
    ]

    makeJsonBody(fromDictionary: responseDict, withResponse: response)
}

private func getUserHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    guard let user_id = request.urlVariables["id"] else {
        fatalError("No user ID given.")
    }

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonBody(fromDictionary: responseDict, withResponse: response)
}

func getUsersRoutes() -> Routes {
    var usersRoutes = Routes()
    usersRoutes.add(method: .get, uri: "/users", handler: getUsersHandler)
    usersRoutes.add(method: .post, uri: "/users", handler: postUsersHandler)
    usersRoutes.add(method: .get, uri: "/users/{id}", handler: getUserHandler)
    return usersRoutes
}
