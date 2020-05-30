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

struct Message: Encodable {
    let roomId: Int
    let text: String
    private let selfUnread: Int = 0

    private enum CodingKeys: String, CodingKey {
        case text = "body"
        case selfUnread = "self_unread"
    }
}

struct CreateMessageResponse: Decodable {
    let messageId: String
}

struct ChatworkClient {
    private let token: String

    init(config: Config) {
        token = config.chatworkToken
    }

    func send(_ message: Message) {
        let baseUrl = "https://api.chatwork.com/v2"
        let urlString = "\(baseUrl)/rooms/\(message.roomId)/messages"
        guard let url = URL(string: urlString) else { return }
        let httpBody: Data
        do {
            let encoder = JSONEncoder.init()
            encoder.dataEncodingStrategy = .deferredToData
            encoder.outputFormatting = .prettyPrinted
            httpBody = try encoder.encode(message)

        } catch {
            fatalError(error.localizedDescription)
        }
        let request: URLRequest = { url, httpBody in
            var request = URLRequest.init(url: url)
            request.httpMethod = "POST"
            request.setValue(token, forHTTPHeaderField: "X-ChatWorkToken")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = "body=\(message.text)&self_unread=0".data(using: .utf8)
            return request
        }(url, httpBody)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            guard let response = response as? HTTPURLResponse else { fatalError("No Response") }
            switch response.statusCode {
            case 200..<300: break
            default:
                fatalError(response.description)
            }

            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decoded = try decoder.decode(CreateMessageResponse.self, from: data)
                print("MessageId: \(decoded.messageId)")
            } catch let decodeError {
                fatalError(decodeError.localizedDescription)
            }
        }
        task.resume()
        semaphore.wait()
    }
}

do {
    let config = try getConfig()
    print("Chatwork Token: \(config.chatworkToken)")
    let message = Message(roomId: config.roomId, text: "Hello, This is MonchCLI!")
    let client = ChatworkClient(config: config)
    client.send(message)
} catch {
    print(error.localizedDescription)
}

