//
//  NetworkError.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

enum NetworkError: Int, Error, CustomStringConvertible {
    var description: String { self.errorDescription }
    
    case invalidURLError
    case typeDecodingError
    case dataDecodingError
    case responseDecodingError
    case invalidRequest
    case unknownError
    
    var errorDescription: String {
        switch self {
        case .invalidURLError:
            return "URL을 변환할 수 없습니다."
        case .typeDecodingError:
            return "데이터를 타입으로 캐스팅하지 못하였습니다."
        case .dataDecodingError:
            return "반환된 데이터가 존재하지 않습니다."
        case .responseDecodingError:
            return "반환된 응답을 해석하지 못했습니다."
        case .invalidRequest:
            return "잘못된 응답이 발생하였습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생하였습니다."
        }
    }
    
    init?(rawValue: Int) {
        switch rawValue {
        case 400...500:
            self = .invalidRequest
        default:
            self = .unknownError
        }
    }
}
