//
//  MinimalRepositoryResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct MinimalRepositoryResponse: Decodable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let url: String
}
