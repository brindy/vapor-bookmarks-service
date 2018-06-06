
import FluentSQLite
import Vapor

final class Bookmarks: SQLiteUUIDModel {
    
    var id: UUID?
    
    var json: String
    
    init(id: UUID? = nil, json: String) {
        self.id = id
        self.json = json
    }
    
}

extension Bookmarks: Migration { }
extension Bookmarks: Content { }
extension Bookmarks: Parameter { }
