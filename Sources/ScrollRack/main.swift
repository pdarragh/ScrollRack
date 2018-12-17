import PerfectHTTP
import PerfectHTTPServer

// MARK: Routes

var apiRoutesV1 = Routes(baseUri: "/v1")
apiRoutesV1.add(getUsersRoutes())

var apiRoutes = Routes(baseUri: "/api")
apiRoutes.add(apiRoutesV1)

var routes = Routes()
routes.add(method: .get, uri: "/") {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>").completed()
}
routes.add(apiRoutes)

// MARK: Server Start

do {
    // Launch the HTTP server.
    try HTTPServer.launch(.server(name: "localhost",
                                  port: 8181,
                                  routes: routes))
} catch {
    fatalError("\(error)")
}
