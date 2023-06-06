//
//  DiaryService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

protocol DiaryServicing: AnyObject {
    func loadDiaries(with token: String) -> Observable<Diaries>
    func searchDiaries(with token: String, query: String) -> Observable<Diaries>
    func createNewDiary(with token: String, diary: [String: Any]?) -> Observable<Void>
    func updateDiary(with token: String, to id: String, diary: [String: Any]?) -> Observable<Void>
    
//    func deleteDiary(
//        with token: String,
//        to id: String
//    ) -> Observable<Void>
}

final class DiaryService: DiaryServicing {
    func loadDiaries(with token: String) -> Observable<Diaries> {
        let api = API.loadDiaries(token: token)
        return DefaultNetworkService().request(to: api)
    }
    
    func searchDiaries(with token: String, query: String) -> Observable<Diaries> {
        let api = API.searchDiaries(token: token, query: query)
        return DefaultNetworkService().request(to: api)
    }
    
    func createNewDiary(with token: String, diary: [String: Any]?) -> Observable<Void> {
        let api = API.createDiary(token: token, diary: diary)
        return DefaultNetworkService().request(to: api)
    }
    
    func updateDiary(with token: String, to id: String, diary: [String : Any]?) -> Observable<Void> {
        let api = API.updateDiary(token: token, id: id, diary: diary)
        return DefaultNetworkService().request(to: api)
    }
    
//    func deleteDiary(
//        with token: String,
//        to id: String
//    ) -> Observable<Void> {
//        let api = API.removeDiary(token: token, id: id)
//        return DefaultNetworkService().request(to: api)
//    }
}

protocol APIType {
    var baseURL: String { get }
    var method: String { get }
    var path: String { get }
    var params: [String: String] { get }
    var body: [String: Any]? { get }
    var headers: [String: String] { get }
    
    func generateRequest() throws -> URLRequest
}

private extension DiaryService {
    enum API {
        case loadDiaries(token: String)
        case searchDiaries(token: String, query: String)
        case createDiary(token: String, diary: [String: Any]?)
        case updateDiary(token: String, id: String, diary: [String: Any]?)
        case removeDiary(token: String, id: String)
    }
}

extension DiaryService.API: APIType {
    var baseURL: String {
        return "https://parseapi.back4app.com" + path
    }
    
    var path: String {
        switch self {
        case .loadDiaries, .searchDiaries:
            return "/classes/Diary"
            
        case .createDiary:
            return "/parse/classes/Diary"
            
        case .removeDiary(_, let id), .updateDiary(_, let id, _):
            return "/classes/Diary/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .loadDiaries, .searchDiaries:
            return "GET"
        case .createDiary:
            return "POST"
        case .updateDiary:
            return "PUT"
        case .removeDiary:
            return "DELETE"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .loadDiaries(let token), .removeDiary(let token, _), .searchDiaries(let token, _):
            return [
                "X-Parse-Application-Id": "T5Idi2coPjEwJ1e30yj8qfgcwvxYHnKlnz4HpyLz",
                "X-Parse-REST-API-Key": "8EFZ0dSEauC938nFNQ3MVV3rvIgJzKlDsLhIxf9M",
                "X-Parse-Session-Token": token
            ]
            
        case .createDiary(let token, _), .updateDiary(let token, _, _):
            return [
                "X-Parse-Application-Id": "T5Idi2coPjEwJ1e30yj8qfgcwvxYHnKlnz4HpyLz",
                "X-Parse-REST-API-Key": "8EFZ0dSEauC938nFNQ3MVV3rvIgJzKlDsLhIxf9M",
                "X-Parse-Session-Token": token,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createDiary(_, let diary), .updateDiary(_, _, let diary):
            return diary
        default: return nil
        }
    }
    
    var params: [String: String] {
        switch self {
        case .searchDiaries(_, let query):
            return ["where": query]
        default:
            return [:]
        }
    }
    
    func generateRequest() throws -> URLRequest {
        guard var urlComponent = URLComponents(string: baseURL) else { throw NetworkError.unknownError }
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
            print(String(data: jsonData!, encoding: .utf8))
            request.httpBody = jsonData
        }
        
        return request
    }
    
}
