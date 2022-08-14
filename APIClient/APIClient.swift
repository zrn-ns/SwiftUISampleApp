//
//  APIClient.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation
import Alamofire

public struct APIClient {

    // MARK: - リクエストの結果をハンドラで受け取れるタイプ

    public static func send<Req: APIRequest>(_ request: Req, handler: ((Result<Req.Response, APIError>) -> Void)?) {
        request.asAFDataRequest().responseDecodable(of: Req.Response.self) { response in
            handler?(response.result.mapError { APIError(afError: $0) })
        }
    }

    public static func send<Req: ResponseConvertible>(_ request: Req, handler: ((Result<Req.Converted, APIError>) -> Void)?) {
        send(request) { result in
            handler?(result.map { request.convert($0) })
        }
    }

    // MARK: - Swift-Concurrency対応版

    public static func sendAsync<Req: APIRequest>(_ request: Req) async throws -> Req.Response {
        let result = await request.asAFDataRequest().serializingDecodable(Req.Response.self).result
        switch result {
        case .success(let response):
            return response
        case .failure(let afError):
            throw APIError(afError: afError)
        }
    }

    public static func sendAsync<Req: ResponseConvertible>(_ request: Req) async throws -> Req.Converted {
        let result = await request.asAFDataRequest().serializingDecodable(Req.Response.self).result
        switch result {
        case .success(let response):
            return request.convert(response)
        case .failure(let afError):
            throw APIError(afError: afError)
        }
    }
}

extension APIRequest {
    func asAFDataRequest() -> DataRequest {
        AF.request(url,
                   method: method.toHTTPMethod(),
                   parameters: params,
                   encoder: URLEncodedFormParameterEncoder(destination: .methodDependent),
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil)
    }
}
