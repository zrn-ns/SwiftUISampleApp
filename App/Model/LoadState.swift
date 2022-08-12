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
    case loading
    case error(APIError)
}
