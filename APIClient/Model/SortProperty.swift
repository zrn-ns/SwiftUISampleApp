//
//  SortProperty.swift
//  App
//
//  Created by zrn_ns on 2022/08/12.
//

import Foundation

#warning("アプリ全体のモデルを管理する専用のターゲットがほしい（APIClientから参照するモデルはAPIClientが持たないといけないが、APIClientにモデルを持つのも違和感があるので）")
public enum SortProperty: String, CaseIterable {
    case fullName
    case createdAt
    case updatedAt
    case pushedAt
}

extension SortProperty {
    public func toAPIValue() -> String {
        switch self {
        case .fullName:
            return "full_name"
        case .createdAt:
            return "created"
        case .updatedAt:
            return "updated"
        case .pushedAt:
            return "pushed"
        }
    }
}

extension SortProperty: Identifiable {
    public var id: RawValue { rawValue }
}
