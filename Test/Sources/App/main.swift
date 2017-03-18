import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)

drop.get("db") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return JSON(version)
    }
    else {
        return "No db connection"
    }
}

drop.get("delete") { request in
    try User.all().forEach { user in
        try user.delete()
    }
    return try JSON(User.all().makeNode())
}


drop.get("user") { request in
    var user = User(name: "Nikita")
    try user.save()
    return try JSON(User.all().makeNode())
}

//drop.get("first") { requst in
//    return "Hello, world!"
//}
//
//drop.get("path", "1") { requst in
//    return JSON(["result" : 1])
//}
//
//drop.get("Leaf", String.self) { request, name in
//    return try drop.view.make("hello", ["name" : name])
//}
//
//drop.get("justUsers") { request in
//    let users = try ["Nikita", "Artem", "Anton"].makeNode()
//    return try drop.view.make("users", ["users" : users])
//}
//
//drop.get("usersWithEmails") { request in
//    let users = try [
//            ["name" : "Nikita", "email" : "Test1@mail.ru"].makeNode(),
//            ["name" : "Artem",  "email" : "Test2@mail.ru"].makeNode(),
//            ["name" : "Anton",  "email" : "Test3@mail.ru"].makeNode()
//        ].makeNode()
//    return try drop.view.make("usersEmail", ["users" : users])
//}
//
//drop.get("helloAwesome") { request in
//    guard let sayHello = request.data["sayHello"]?.bool else {
//        throw Abort.badRequest
//    }
//    return try drop.view.make("helloAwesome", Node(node: ["sayHello": sayHello.makeNode()]))
//}


drop.run()
