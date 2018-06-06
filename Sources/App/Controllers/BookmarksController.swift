import Vapor

final class BookmarksController {
 
    func fetch(_ req: Request) throws -> Future<String> {
        return try req.parameters.next(Bookmarks.self).map { bookmarks in
            return bookmarks.json
        }
    }

    func create(_ req: Request) throws -> Future<String> {
        return try req.content.decode(Bookmarks.self).flatMap { bookmarks in
            return bookmarks.save(on: req)
        }.map { bookmarks in
            return bookmarks.id!.uuidString
        }
    }

}
