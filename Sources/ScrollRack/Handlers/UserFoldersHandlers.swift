//
//  UserFoldersHandlers.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func getUserFoldersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict: JSON = [
        "user_id": "\(user_id)",
        "folders": [],
        ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func postUserFoldersHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func getUserFolderHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let folder_id = extractUrlVariable("folder_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "folder_id": "\(folder_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func putUserFolderHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let folder_id = extractUrlVariable("folder_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "folder_id": "\(folder_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

private func deleteUserFolderHandler(request: HTTPRequest, response: HTTPResponse) -> () {
    let user_id = extractUrlVariable("user_id", fromRequest: request)
    let folder_id = extractUrlVariable("folder_id", fromRequest: request)

    let responseDict = [
        "user_id": "\(user_id)",
        "folder_id": "\(folder_id)",
    ]

    makeJsonResponseBody(fromDictionary: responseDict, withResponse: response)
}

func getUserFoldersRoutes() -> Routes {
    var routes = Routes(baseUri: "/users/{user_id}")
    routes.add(method: .get, uri: "/folders", handler: getUserFoldersHandler)
    routes.add(method: .post, uri: "/folders", handler: postUserFoldersHandler)
    routes.add(method: .get, uri: "/folders/{folder_id}", handler: getUserFolderHandler)
    routes.add(method: .put, uri: "/folders/{folder_id}", handler: putUserFolderHandler)
    routes.add(method: .delete, uri: "/folders/{folder_id}", handler: deleteUserFolderHandler)
    return routes
}
