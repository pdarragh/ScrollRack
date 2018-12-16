import PerfectHTTP
import PerfectHTTPServer

// MARK: Routes
var routes = Routes()
routes.add(method: .get, uri: "/") {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>").completed()
}

do {
    // Launch the HTTP server.
    try HTTPServer.launch(.server(name: "localhost",
                                  port: 8181,
                                  routes: routes))
} catch {
    fatalError("\(error)")
}
