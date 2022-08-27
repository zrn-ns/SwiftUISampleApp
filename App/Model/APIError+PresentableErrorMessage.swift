//
//  APIError+PresentableErrorMessage.swift
//  App
//
//  Created by zrn_ns on 2022/08/27.
//

import APIClient
import Foundation

extension APIError {
    func presentableErrorMessage() -> String {
        switch self {
        case .connectionFailure:
            return Localizable.apiErrorConnectionFailure()
        case .logicError(systemErrorInfo: _):
            return Localizable.apiErrorLogicError()
        case .userInputError(systemErrorInfo: _):
            return Localizable.apiErrorUserInputError()
        case .cancelled:
            return Localizable.apiErrorCancelled()
        }
    }
}
