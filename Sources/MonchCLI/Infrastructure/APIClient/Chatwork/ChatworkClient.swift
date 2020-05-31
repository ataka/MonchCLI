//
//  ChatworkClient.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

struct ChatworkClient {
    static let baseUrl = "https://api.chatwork.com/v2"
    private let config: Config.Chatwork

    init(config: Config.Chatwork) {
        self.config = config
    }

    func send<Request: ChatworkApiRequest>(_ request: Request, completionHandler: @escaping (_ response: Request.Response) -> Void) {
        guard var request = request.makeURLRequest(baseUrl: Self.baseUrl) else { return }
        request.setValue(config.token, forHTTPHeaderField: "X-ChatWorkToken")

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
                let decoded = try decoder.decode(Request.Response.self, from: data)
                completionHandler(decoded)
            } catch let decodeError {
                fatalError(decodeError.localizedDescription)
            }
        }
        task.resume()
        semaphore.wait()
    }
}
