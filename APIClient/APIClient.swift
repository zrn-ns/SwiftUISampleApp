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
        request.asAFDataRequest().responseDecodable(of: Req.Response.self) { response in
            handler?(response.result.mapError { APIError(afError: $0) })
        }
    }

    public static func sendAsync<Req: APIRequest>(_ request: Req) async throws -> Req.Response {
        let result = await request.asAFDataRequest().serializingDecodable(Req.Response.self).result
        switch result {
        case .success(let response):
            return response
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
