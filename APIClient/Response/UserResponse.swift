//
//  UserResponse.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/11.
//

import Foundation

public struct User: APIResponse {
    public let id: Int
    public let login: String
    public let name: String
    public let bio: String?
    public let htmlUrl: URL
    public let avatarUrl: URL
    public let followers: Int
    public let following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case bio
        case htmlUrl = "html_url"
        case avatarUrl = "avatar_url"
        case followers
        case following
    }

    init(id: Int, login: String, name: String, bio: String?, htmlUrl: URL, avatarUrl: URL, followers: Int, following: Int) {
        self.id = id
        self.login = login
        self.name = name
        self.bio = bio
        self.htmlUrl = htmlUrl
        self.avatarUrl = avatarUrl
        self.followers = followers
        self.following = following
    }
}
