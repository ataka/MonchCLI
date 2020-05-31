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

func selectPullRequests(with config: Config, completionHandler: @escaping (PullRequest) -> Void) {
    let request = ListPullRequestsRequest()
    let githubClient = GithubClient(config: config.github)
    githubClient.send(request) { pullRequests in
            let listPullRequest = pullRequests
            .prefix(8)
            .enumerated()
            .map({ (offset, pullRequest) in
                "[\(offset)] \(pullRequest.title)"
            })
            .joined(separator: "\n")

        print(listPullRequest)
        print("\n> PR を番号で選択してください: ")
        guard let read = readLine(),
            let index = Int(read) else { return }

        let pullRequest = pullRequests[index]
        completionHandler(pullRequest)
    }
}

func requestCodeReview(for pullRequest: PullRequest, with config: Config, completionHandler: @escaping () -> Void) {
    let listRewiewers = config.reviewers
        .enumerated()
        .map { (offset, reviewer) in
            "[\(offset)] \(reviewer.name)"
        }
        .joined(separator: "\n")

    print(listRewiewers)
    print("\n> レビュワーを選んでください: ")
    guard let read = readLine() else { return }

    let assignees = read
        .split(separator: ",")
        .map(String.init)
        .compactMap(Int.init)
        .map { config.reviewers[$0] }

    let text = """
    \(pullRequest.title)
    \(pullRequest.url)

    レビューをお願いします (please)
    """

    //        let request = CreateMessageRequest(roomId: config.chatwork.roomId, text: "Hello, This is MonchCLI!")
    let request = CreateTaskRequest(roomId: config.chatwork.roomId, text: text, limitType: .none, assigneeIds: assignees.map { $0.chatworkId })
    let chatworkClient = ChatworkClient(config: config.chatwork)
    chatworkClient.send(request) { taskResponse in
//        print("TaskIds = \(taskResponse.taskIds)")
        completionHandler()
    }
}

func main() {
    let config: Config
    do {
        config = try getConfig()
    } catch {
        fatalError(error.localizedDescription)
    }
    let semaphore = DispatchSemaphore(value: 0)
    selectPullRequests(with: config) { pullRequest in
        requestCodeReview(for: pullRequest, with: config) {
            print("タスクを振りました。")
            semaphore.signal()
        }
    }
    semaphore.wait()
}

main()

