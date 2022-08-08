//
//  MinimalRepositoryResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct MinimalRepository: APIResponse {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let url: String
    public let stargazersCount: Int
}
