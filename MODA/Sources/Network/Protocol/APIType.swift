//
//  APIType.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol APIType {
    var baseURL: String { get }
    var method: String { get }
    var path: String { get }
    var params: [String: String] { get }
    var body: [String: Any]? { get }
    var headers: [String: String] { get }
    
    func generateRequest() throws -> URLRequest
}

extension APIType {
    func generateRequest() throws -> URLRequest {
        guard var urlComponent = URLComponents(string: baseURL + path) else { throw NetworkError.unknownError }
        let parameters = params.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        
        urlComponent.queryItems = parameters
        
        guard let url = urlComponent.url else {
            throw NetworkError.unknownError
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        
        if let body = body {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        return request
    }
}
