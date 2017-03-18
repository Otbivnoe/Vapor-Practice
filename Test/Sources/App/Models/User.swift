//
//  User.swift
//  vapor-practice
//
//  Created by Nikita Ermolenko on 13/02/2017.
//
//

import Vapor
import Fluent

final class User: Model {
    
    var id: Node?
    var name: String
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    init(name: String) {
        self.name = name
    }
    
    /// We need to show it how to save back into the database.
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id"   : id,
            "name" : name
            ])
    }
}

// MARK: - Preparation

extension User {
    
    /// Some databases, like MySQL, need to be prepared for a new schema.
    /// In MySQL, this means creating a new table. Preparations are also equatable to migrations, as they can be used to alter schemas after they've already been created.
    
    static func prepare(_ database: Database) throws {
        
        /// Here we create a table named users that has an identifier field and a string field with the key name
        /// This matches both our init(node: Node) and makeNode() -> Node methods.
        
        try database.create("users") { users in
            users.id()
            users.string("name")
        }
    }
    
    /// An optional preparation reversion can be created. 
    /// This will be run if vapor run prepare --revert is called.
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}
