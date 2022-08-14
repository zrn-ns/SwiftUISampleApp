//
//  SortDirection.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/14.
//

import Foundation

public enum SortDirection {
    case none
    case ascend
    case descend

    public func toAPIValue() -> String? {
        switch self {
        case .none:
            return nil
        case .ascend:
            return "asc"
        case .descend:
            return "desc"
        }
    }

    public func toUserDefaultValue() -> String {
        switch self {
        case .none:
            return "none"
        case .ascend:
            return "ascend"
        case .descend:
            return "descend"
        }
    }

    public init?(userDefaultValue: String) {
        switch userDefaultValue {
        case "none":
            self = .none
        case "ascend":
            self = .ascend
        case "descend":
            self = .descend
        default:
            self = .none
        }
    }
}
