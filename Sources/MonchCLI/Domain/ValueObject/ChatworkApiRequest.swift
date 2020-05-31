//
//  ChatworkApiRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

protocol ApiRequest: Encodable {
    associatedtype ApiResponse: Decodable
    var path: String { get }
    func makeURLRequest(baseUrl: String) -> URLRequest?
}

protocol ChatworkApiRequest: ApiRequest {}

extension ChatworkApiRequest {
    func makeURLRequest(baseUrl: String) -> URLRequest? {
        guard let url = URL(string: "\(baseUrl)/\(path)") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try XWWWFormUrlEncoder().encode(self)
        } catch {
            fatalError(error.localizedDescription)
        }
        return request
    }
}