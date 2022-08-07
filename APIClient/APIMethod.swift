//
//  APIMethod.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Alamofire
import Foundation

public enum APIMethod {
    case get
    case post

    internal func toHTTPMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
