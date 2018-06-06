import Vapor

final class BookmarksController {
 
    func fetch(_ req: Request) throws -> Future<HTTPResponse> {

        return try req.parameters.next(Bookmarks.self).map { bookmarks in
            var headers = HTTPHeaders()
            headers.replaceOrAdd(name: .contentType, value: "application/json")
            
            var response: HTTPResponse = HTTPResponse(status: .ok)
            response.body = HTTPBody(string: bookmarks.json)
            response.headers = headers
            
            return response
        }
    }

    func create(_ req: Request) throws -> Future<HTTPResponse> {
        guard let data = req.http.body.data else {
            throw Abort(.badRequest, reason: "No body")
        }
        
        guard (try? JSONSerialization.jsonObject(with: data)) != nil else {
            throw Abort(.badRequest, reason: "Invalid JSON")
        }

        // TODO test the json contains valid elements
        
        guard let bookmarksJson = String(data: data, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "Body was not utf8 encoded")
        }

        let bookmarks = Bookmarks(id: nil, json: bookmarksJson)

        var response: HTTPResponse = HTTPResponse(status: .created)

        return bookmarks.save(on: req).map { bookmarks in
            var headers = HTTPHeaders()
            headers.replaceOrAdd(name: .location, value: bookmarks.id!.uuidString)
            response.headers = headers
        }.transform(to: response)
    }

}
