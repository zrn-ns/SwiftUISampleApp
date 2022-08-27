//
//  APIError.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Alamofire
import Foundation

public enum APIError: Error, Equatable {
    /// サーバ不達
    case connectionFailure
    /// クライアント側のロジックエラー
    case logicError(systemErrorInfo: String)
    /// ユーザの入力ミス
    case userInputError(systemErrorInfo: String)
    /// キャンセルされた
    case cancelled
    /// その他
    case other

    init(afError: AFError) {
        switch afError {
        case .createUploadableFailed(let error),
                .createURLRequestFailed(let error),
                .downloadedFileMoveFailed(let error, _, _),
                .requestAdaptationFailed(let error):
            self = .logicError(systemErrorInfo: error.localizedDescription)
        case .explicitlyCancelled:
            self = .cancelled
        case .invalidURL(let url):
            self = .userInputError(systemErrorInfo: "invalid url: \(url)")
        case .multipartEncodingFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .parameterEncodingFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .parameterEncoderFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .requestRetryFailed(let retryError, _):
            self = .logicError(systemErrorInfo: retryError.localizedDescription)
        case .responseValidationFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .responseSerializationFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .serverTrustEvaluationFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        case .sessionDeinitialized:
            self = .connectionFailure
        case .sessionInvalidated(_):
            self = .connectionFailure
        case .sessionTaskFailed(_):
            self = .connectionFailure
        case .urlRequestValidationFailed(let reason):
            self = .logicError(systemErrorInfo: "\(reason)")
        }
        self = .other
    }
}
