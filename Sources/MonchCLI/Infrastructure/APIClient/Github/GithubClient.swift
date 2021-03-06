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

    func send<Request: GithubApiBaseRequest>(_ request: Request, completionHandler: @escaping (_ response: Request.Response) -> Void) {
        guard var request = request.makeURLRequest(baseUrl: baseUrl) else { return }
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

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
    }

    private var authorization: String { "token \(config.token)" }
}
