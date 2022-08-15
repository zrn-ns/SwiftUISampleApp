//
//  MinimalGithubRepositoryResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct MinimalGithubRepository: APIResponse {
    public let id: Int
    public let name: String
    public let description: String?
    public let language: String?
    public let stargazersCount: Int
    public let htmlUrl: URL
    public let isFork: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
        case isFork = "fork"
    }

    public init(id: Int, name: String, description: String?, language: String?, stargazersCount: Int, htmlUrl: URL, isFork: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.language = language
        self.stargazersCount = stargazersCount
        self.htmlUrl = htmlUrl
        self.isFork = isFork
    }
}

extension MinimalGithubRepository: Identifiable {}
