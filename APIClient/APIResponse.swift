//
//  APIResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/08.
//

import Foundation

public protocol APIResponse: Decodable {}

extension Array: APIResponse where Element: APIResponse {}
