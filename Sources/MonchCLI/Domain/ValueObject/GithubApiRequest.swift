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
        let param: String
        do {
            let data = try XWWWFormUrlEncoder().encode(self)
            param = String(data: data, encoding: .utf8)!
        } catch {
            fatalError(error.localizedDescription)
        }
        guard let url = URL(string: "\(baseUrl)/\(path)?\(param)") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
