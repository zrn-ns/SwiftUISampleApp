//
//  GetUserRequest.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/11.
//

import Foundation

public struct GetUserRequest: APIRequest {
    public typealias Response = User

    public var url: URL {
        guard let encodedUserId: String = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            preconditionFailure("URLの生成に失敗しました")
        }
        return .init(string: "https://api.github.com/users/\(encodedUserId)")!
    }
    public var method: APIMethod = .get

    public init(userId: String) {
        self.userId = userId
    }

    // MARK: - private

    private let userId: String
}
