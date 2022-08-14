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
        var params: Params = ["sort": sortProperty.toAPIValue(),
                              "page": String(nextPage),
                              "per_page": String(itemsPerPage)]
        if let direction = sortDirection.toAPIValue() {
            params["direction"] = direction
        }
        return params
    }

    public init(userId: String, sortProperty: SortProperty, sortDirection: SortDirection, pagingParam: PagingParam? = nil) {
        self.userId = userId
        self.sortProperty = sortProperty
        self.sortDirection = sortDirection
        self.pagingParam = pagingParam
    }

    // MARK: - private

    private let itemsPerPage: Int = 30
    private let userId: String
    private let sortProperty: SortProperty
    private let sortDirection: SortDirection
    private let pagingParam: PagingParam?

    private var nextPage: Int {
        guard let pagingParam else { return 1 }

        return pagingParam.currentPage + 1
    }
}

extension GetRepositoryListRequest: ResponseConvertible {
    public struct Converted {
        public let repositories: [MinimalRepository]
        public let nextPagingParam: PagingParam
    }

    public func convert(_ response: [MinimalRepository]) -> Converted {
        .init(repositories: response,
              nextPagingParam: .init(currentPage: nextPage,
                                     hasNextPage: response.count == itemsPerPage))
    }
}

