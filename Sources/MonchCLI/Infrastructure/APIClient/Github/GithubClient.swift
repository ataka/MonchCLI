//
//  GithubClient.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct GithubClient {
    private let baseUrl: String = "https://api.github.com"
    private let config: Config.Github

    init(config: Config.Github) {
        self.config = config
    }

    func send<Request: GithubApiBaseRequest>(_ request: Request) async throws -> Request.Response {
        guard var request = request.makeURLRequest(baseUrl: baseUrl) else { fatalError() }
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

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

    private var authorization: String { "token \(config.token)" }
}
