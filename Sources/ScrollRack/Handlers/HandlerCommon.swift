//
//  HandlerCommon.swift
//  ScrollRack
//
//  Created by Pierce Darragh on 12/16/18.
//

import PerfectHTTP

private func encodeJson(_ json: [String: Any]) -> String {
    guard let responseString = try? json.jsonEncodedString() else {
        fatalError("Could not encode JSON dictionary.")
    }
    return responseString
}

func makeJsonResponseBody(fromDictionary dict: [String: Any], withResponse response: HTTPResponse) {
    response.setHeader(.contentType, value: "application/json")
    response.setBody(string: encodeJson(dict))
    response.completed()
}
