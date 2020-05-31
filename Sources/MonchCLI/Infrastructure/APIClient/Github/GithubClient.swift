//
//  GithubClient.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

struct GithubClient {
    private static let rootUrl = "https://api.github.com"
    private let baseUrl: String
    private let config: Config.Github

    init(config: Config.Github) {
        self.config = config
        baseUrl = "\(Self.rootUrl)/repos/\(config.repository)"
    }

    func send<Request: GithubApiRequest>(_ request: Request, completionHandler: @escaping (_ response: Request.ApiResponse) -> Void) {
        guard var request = request.makeURLRequest(baseUrl: baseUrl) else { return }
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.sailor-v-preview+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

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
                let decoded = try decoder.decode(Request.ApiResponse.self, from: data)
                completionHandler(decoded)
            } catch let decodeError {
                fatalError(decodeError.localizedDescription)
            }
        }
        task.resume()
        semaphore.wait()
    }

    private var authorization: String { "token \(config.token)" }
}
