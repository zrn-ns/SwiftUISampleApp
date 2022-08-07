//
//  APIClient.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation
import Alamofire

public struct APIClient {
    public static func send<Req: APIRequest>(_ request: Req) async -> Result<Req.Response, APIError> {
        let result = await AF.request(request.url,
                                      method: request.method.toHTTPMethod(),
                                      parameters: request.params,
                                      encoder: .urlEncodedForm,
                                      headers: nil,
                                      interceptor: nil,
                                      requestModifier: nil).serializingDecodable(Req.Response.self).result
        return result.mapError { APIError(afError: $0) }
    }
}
