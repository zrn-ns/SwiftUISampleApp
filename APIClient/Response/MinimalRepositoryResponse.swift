//
//  MinimalRepositoryResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct MinimalRepository: APIResponse {
    public let id: Int
    public let name: String
    public let description: String?
    public let language: String?
    public let stargazersCount: Int
    public let htmlUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
    }

    public init(id: Int, name: String, description: String?, language: String?, stargazersCount: Int, htmlUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.language = language
        self.stargazersCount = stargazersCount
        self.htmlUrl = htmlUrl
    }
}

extension MinimalRepository: Identifiable {}
