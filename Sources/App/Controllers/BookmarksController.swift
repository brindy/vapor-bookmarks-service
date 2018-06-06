import Vapor

final class BookmarksController {
 
    func fetch(_ req: Request) throws -> Future<String> {
        return try req.parameters.next(Bookmarks.self).map { bookmarks in
            return bookmarks.json
        }
    }

    func create(_ req: Request) throws -> Future<String> {
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
        return bookmarks.save(on: req).map { bookmarks in
            return bookmarks.id!.uuidString
        }
        
    }

}
