//
//  GetRepositoryListRequest.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct GetRepositoryListRequest: APIRequest {
    public typealias Response = [MinimalRepositoryResponse]

    public var url: URL {
        guard let encodedUserId: String = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            preconditionFailure("URLの生成に失敗しました")
        }
        return .init(string: "https://api.github.com/users/\(encodedUserId)/repos")!
    }
    public var method: APIMethod = .get
    public var params: [String: String]? = nil

    public init(userId: String) {
        self.userId = userId
    }

    // MARK: - private

    private let userId: String
}
