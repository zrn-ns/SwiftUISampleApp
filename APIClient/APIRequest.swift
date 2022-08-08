//
//  APIRequest.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Alamofire
import Foundation

public protocol APIRequest {
    associatedtype Response: APIResponse

    var url: URL { get }
    var method: APIMethod { get }
    var params: [String: String]? { get }
}

public extension APIRequest {
    var method: APIMethod { .get }
    var params: [String: String]? { nil }
}
