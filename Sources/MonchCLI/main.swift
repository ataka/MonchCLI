import Foundation

func getConfig() throws -> Config {
    let fileName = "config.plist"
    #if DEBUG
    let pathString: String = { (path: String) in
        URL(fileURLWithPath: path)
            .pathComponents
            .dropLast(3)
            .joined(separator: "/") + "/\(fileName)"
    }(#file)
    #else
    let pathString = FileManager.default.currentDirectoryPath + "/\(fileName)"
    #endif
    let pathUrl = URL(fileURLWithPath: pathString)

    let data = try Data(contentsOf: pathUrl)
    return try PropertyListDecoder().decode(Config.self, from: data)
}

do {
    let config = try getConfig()
//    let request = CreateMessageRequest(roomId: config.chatwork.roomId, text: "Hello, This is MonchCLI!")
    let request = CreateTaskRequest(roomId: config.chatwork.roomId, text: "This is my task!", limitType: .none, assigneeIds: config.reviewers.map { $0.chatworkId })
    let client = ChatworkClient(config: config.chatwork)
    client.send(request) { taskResponse in
        print("TaskIds = \(taskResponse.taskIds)")
    }
} catch {
    print(error.localizedDescription)
}

