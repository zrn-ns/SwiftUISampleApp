//
//  LoadState.swift
//  App
//
//  Created by zrn_ns on 2022/08/08.
//

import APIClient
import Foundation

enum LoadState: Equatable {
    case normal
    case paging
    case loading
    case error(APIError)

    func isNotFetching() -> Bool {
        switch self {
        case .normal, .error:
            return true
        case .paging, .loading:
            return false
        }
    }
}
