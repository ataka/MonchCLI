//
//  ApiRequest.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/31.
//

import Foundation

protocol ApiRequest {
    associatedtype Response: ApiResponse
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    func makeURLRequest(baseUrl: String) -> URLRequest?
}

protocol ApiResponse: Decodable {}

enum HTTPMethod: String {
    case post   = "POST"
    case get    = "GET"
    case update = "UPDATE"
    case delete = "DELETE"
}
