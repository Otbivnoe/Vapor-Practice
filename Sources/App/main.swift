import Vapor

let drop = Droplet()

drop.get("first") { requst in
    return "Hello, world!"
}

drop.get("path", "1") { requst in
    return JSON(["result" : 1])
}

drop.get("Leaf", String.self) { request, name in
    return try drop.view.make("hello", ["name" : name])
}

drop.get("justUsers") { request in
    let users = try ["Nikita", "Artem", "Anton"].makeNode()
    return try drop.view.make("users", ["users" : users])
}

drop.get("usersWithEmails") { request in
    let users = try [
            ["name" : "Nikita", "email" : "Test1@mail.ru"].makeNode(),
            ["name" : "Artem",  "email" : "Test2@mail.ru"].makeNode(),
            ["name" : "Anton",  "email" : "Test3@mail.ru"].makeNode()
        ].makeNode()
    return try drop.view.make("usersEmail", ["users" : users])
}

drop.get("helloAwesome") { request in
    guard let sayHello = request.data["sayHello"]?.bool else {
        throw Abort.badRequest
    }
    return try drop.view.make("helloAwesome", Node(node: ["sayHello": sayHello.makeNode()]))
}


drop.run()
