//
//  DiaryService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

protocol DiaryServicing: AnyObject {
    func loadDiaries() -> Observable<Diaries>
    func searchDiaries(query: String, option: [String: String]) -> Observable<Diaries>
    func createNewDiary(content: String, condition: Int) -> Observable<Void>
    func updateDiary(to id: String, content: String, condition: Int, isLike: Bool) -> Observable<Void>
    func removeDiary(id: String) -> Observable<Void>
}

final class DiaryService: DiaryServicing {
    private let user: User
    
    init() {
        if let userData = UserDefaults.standard.object(forKey: "currentUser") as? Data,
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.user = user
        } else {
            self.user = User.empty
        }
    }
    
    func loadDiaries() -> Observable<Diaries> {
        let api = API.loadDiaries(token: user.sessionToken)
        return DefaultNetworkService().request(to: api)
    }
    
    func searchDiaries(query: String, option: [String: String] = [:]) -> Observable<Diaries> {
        let userPoint = UserPointer(id: user.identifier).query
        let userQuery = "{\(userPoint), \(query)}"
        let api = API.searchDiaries(token: user.sessionToken, query: userQuery, option: option)
        return DefaultNetworkService().request(to: api)
    }
    
    func createNewDiary(content: String, condition: Int) -> Observable<Void> {
        let requestDTO = DiaryRequestDTO(
            content: content,
            condition: condition,
            userId: user.identifier
        )
        
        let api = API.createDiary(token: user.sessionToken, diary: requestDTO.toDictionary)
        return DefaultNetworkService().request(to: api)
    }
    
    func updateDiary(to id: String, content: String, condition: Int, isLike: Bool) -> Observable<Void> {
        let requestDTO = DiaryUpdateDTO(content: content, condition: condition, isLike: isLike)
        let api = API.updateDiary(
            token: user.sessionToken,
            id: id,
            diary: requestDTO.toDictionary
        )
        return DefaultNetworkService().request(to: api)
    }
    
    func removeDiary(id: String) -> Observable<Void> {
        let api = API.removeDiary(token: user.sessionToken, id: id)
        return DefaultNetworkService().request(to: api)
    }
}


private extension DiaryService {
    enum API {
        case loadDiaries(token: String)
        case searchDiaries(token: String, query: String, option: [String: String])
        case createDiary(token: String, diary: [String: Any]?)
        case updateDiary(token: String, id: String, diary: [String: Any]?)
        case removeDiary(token: String, id: String)
    }
}

extension DiaryService.API: APIType {
    var baseURL: String {
        return "https://parseapi.back4app.com"
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
        case .loadDiaries(let token), .removeDiary(let token, _), .searchDiaries(let token, _, _):
            return [
                "X-Parse-Session-Token": token
            ]
            
        case .createDiary(let token, _), .updateDiary(let token, _, _):
            return [
                "X-Parse-Session-Token": token,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createDiary(_, let diary), .updateDiary(_, _, let diary):
            return diary
        case .loadDiaries:
            return ["order": "createdDay"]
        default: return nil
        }
    }
    
    var params: [String: String] {
        switch self {
        case .searchDiaries(_, let query, let option):
            var params = ["where": query]
            option.forEach {
                params[$0.key] = $0.value
            }
            return params
        default:
            return [:]
        }
    }
}
