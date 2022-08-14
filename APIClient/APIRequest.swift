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
    var params: Params? { get }
}

public extension APIRequest {
    var method: APIMethod { .get }
    var params: Params? { return nil }
}

public typealias Params = [String: String]

/// Responseを別のモデルとして受け取れるRequest。
/// API側のモデルとアプリ側のモデルを切り分けたい場合や、リクエストに保持している
/// プロパティをレスポンスに付加したい場合などに使う。
public protocol ResponseConvertible: APIRequest {
    associatedtype Converted

    func convert(_ response: Response) -> Converted
}
