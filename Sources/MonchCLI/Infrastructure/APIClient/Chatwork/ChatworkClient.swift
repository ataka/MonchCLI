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

    func send<Request: ChatworkApiRequest>(_ request: Request) async throws -> Request.Response {
        guard var request = request.makeURLRequest(baseUrl: Self.baseUrl) else { fatalError() }
        request.setValue(config.token, forHTTPHeaderField: "X-ChatWorkToken")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard case let httpResponse as HTTPURLResponse = response else { fatalError() }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        default:
            fatalError(response.description)
        }

        let decoder: JSONDecoder = { decoder in
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }(JSONDecoder())
        let decoded = try decoder.decode(Request.Response.self, from: data)
        return decoded
    }
}
