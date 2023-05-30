//
//  DiaryService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

protocol DiaryServicing: AnyObject {
    func loadDiaries(with token: String) -> Observable<[Diary]>
}

final class DiaryService: DiaryServicing {
    func loadDiaries(with token: String) -> Observable<[Diary]> {
        guard let request = try? API.loadDiaries(token: token).generateRequest() else {
            return Observable.error(URLError(.badURL))
        }
        
        let decoder = JSONDecoder().ISODecoder()        
        return URLSession.shared.rx.data(request: request)
            .decode(type: Diaries.self, decoder: decoder)
            .map { $0.results }
            .catchAndReturn([])
    }
}

protocol APIType {
    var baseURL: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    
    func generateRequest() throws -> URLRequest
}

private extension DiaryService {
    enum API {
        case loadDiaries(token: String)
    }
}

extension DiaryService.API: APIType {
    var baseURL: String {
        return "https://parseapi.back4app.com/classes/Diary"
    }
    
    var method: String {
        switch self {
        case .loadDiaries:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .loadDiaries(let token):
            return [
                "X-Parse-Application-Id": "T5Idi2coPjEwJ1e30yj8qfgcwvxYHnKlnz4HpyLz",
                "X-Parse-REST-API-Key": "8EFZ0dSEauC938nFNQ3MVV3rvIgJzKlDsLhIxf9M",
                "X-Parse-Session-Token": token
            ]
        }
    }
    
    func generateRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw URLError(.unsupportedURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        
        return request
    }
    
}
