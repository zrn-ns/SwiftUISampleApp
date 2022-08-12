//
//  GetRepositoryListRequest.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation

public struct GetRepositoryListRequest: APIRequest {
    public typealias Response = [MinimalRepository]

    public var url: URL {
        guard let encodedUserId: String = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            preconditionFailure("URLの生成に失敗しました")
        }
        return .init(string: "https://api.github.com/users/\(encodedUserId)/repos")!
    }
    public var method: APIMethod = .get
    public var params: Params? {
        ["sort": sortProperty.toAPIValue()]
    }

    public init(userId: String, sortProperty: SortProperty) {
        self.userId = userId
        self.sortProperty = sortProperty
    }

    // MARK: - private

    private let userId: String
    private let sortProperty: SortProperty
}
