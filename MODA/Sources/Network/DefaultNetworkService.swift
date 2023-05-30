//
//  DefaultNetworkService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol NetworkService: AnyObject {
    func request<T: Decodable>(to api: APIType) -> Observable<T>
}

final class DefaultNetworkService: NetworkService {
    func request<T: Decodable>(to api: APIType) -> Observable<T> {
        return Observable.create { emitter in
            guard let request = try? api.generateRequest() else {
                emitter.onError(NetworkError.invalidURLError)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    emitter.onError(NetworkError.responseDecodingError)
                    return
                }
                
                guard (200...300) ~= response.statusCode else {
                    let error = NetworkError(rawValue: response.statusCode) ?? .unknownError
                    emitter.onError(error)
                    return
                }
                
                guard let data = data else {
                    emitter.onError(NetworkError.dataDecodingError)
                    return
                }
                
                let decoder = JSONDecoder().ISODecoder()
                guard let values = try? decoder.decode(T.self, from: data) else {
                    emitter.onError(NetworkError.typeDecodingError)
                    return
                }
                
                emitter.onNext(values)
            }.resume()
            
            return Disposables.create()
        }
    }
}
