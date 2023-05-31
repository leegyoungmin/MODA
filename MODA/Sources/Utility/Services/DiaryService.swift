//
//  DiaryService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

protocol DiaryServicing: AnyObject {
    func loadDiaries(with token: String) -> Observable<Diaries>
    
    func deleteDiary(
        with token: String,
        to id: String
    ) -> Observable<Void>
}

final class DiaryService: DiaryServicing {
    func loadDiaries(with token: String) -> Observable<Diaries> {
        let api = API.loadDiaries(token: token)
        return DefaultNetworkService().request(to: api)
    }
    
    func deleteDiary(
        with token: String,
        to id: String
    ) -> Observable<Void> {
        let api = API.removeDiary(token: token, id: id)
        return DefaultNetworkService().request(to: api)
    }
}

protocol APIType {
    var baseURL: String { get }
    var method: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    
    func generateRequest() throws -> URLRequest
}

private extension DiaryService {
    enum API {
        case loadDiaries(token: String)
        case removeDiary(token: String, id: String)
    }
}

extension DiaryService.API: APIType {
    var baseURL: String {
        return "https://parseapi.back4app.com" + path
    }
    
    var path: String {
        switch self {
        case .loadDiaries:
            return "/classes/Diary"
            
        case .removeDiary(_, let id):
            return "/classes/Diary/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .loadDiaries:
            return "GET"
        case .removeDiary:
            return "DELETE"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .loadDiaries(let token), .removeDiary(let token, _):
            return [
                "X-Parse-Application-Id": "T5Idi2coPjEwJ1e30yj8qfgcwvxYHnKlnz4HpyLz",
                "X-Parse-REST-API-Key": "8EFZ0dSEauC938nFNQ3MVV3rvIgJzKlDsLhIxf9M",
                "X-Parse-Session-Token": token
            ]
        }
    }
    
    func generateRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL) else { throw NetworkError.unknownError }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        
        return request
    }
    
}
