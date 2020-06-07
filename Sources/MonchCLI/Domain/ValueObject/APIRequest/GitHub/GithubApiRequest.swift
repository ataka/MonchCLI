//
//  GithubApiRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

protocol GithubApiRequest: ApiRequest {}
protocol GithubApiResponse: ApiResponse {}

extension GithubApiRequest {
    func makeURLRequest(baseUrl: String) -> URLRequest? {
        switch httpMethod {
        case .get:
            let param: String
            do {
                let data = try XWWWFormUrlEncoder().encode(self)
                param = String(data: data, encoding: .utf8)!
            } catch {
                fatalError(error.localizedDescription)
            }
            guard let url = URL(string: "\(baseUrl)/\(path)?\(param)") else { return nil }

            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            return request
        case .post:
            guard let url = URL(string: "\(baseUrl)/\(path)") else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            do {
                request.httpBody = try JSONEncoder().encode(self)
            } catch {
                fatalError(error.localizedDescription)
            }
            return request
        default:
            fatalError("Not implemented!")
        }
    }
}
