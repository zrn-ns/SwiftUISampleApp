//
//  APIClient.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation
import Alamofire

public struct APIClient {
    public static func send<Req: APIRequest>(_ request: Req, handler: ((Result<Req.Response, APIError>) -> Void)?) {
        AF.request(request.url,
                   method: request.method.toHTTPMethod(),
                   parameters: request.params,
                   encoder: .urlEncodedForm,
                   headers: nil,
                   interceptor: nil,
                   requestModifier: nil).responseDecodable(of: Req.Response.self) { response in
            handler?(response.result.mapError { APIError(afError: $0) })
        }
    }

    public static func sendAsync<Req: APIRequest>(_ request: Req) async throws -> Req.Response {
        let result = await AF.request(request.url,
                                      method: request.method.toHTTPMethod(),
                                      parameters: request.params,
                                      encoder: .urlEncodedForm,
                                      headers: nil,
                                      interceptor: nil,
                                      requestModifier: nil).serializingDecodable(Req.Response.self).result
        switch result {
        case .success(let response):
            return response
        case .failure(let afError):
            throw APIError(afError: afError)
        }
    }
}
