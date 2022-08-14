//
//  SortDirection+Extension.swift
//  App
//
//  Created by zrn_ns on 2022/08/14.
//

import APIClient
import Foundation

extension SortDirection {
    public func pickerText() -> String {
        switch self {
        case .none:
            return Localizable.sortDirectionDefault()
        case .ascend:
            return Localizable.sortDirectionAscend()
        case .descend:
            return Localizable.sortDirectionDescend()
        }
    }

    public static func pickerSelections() -> [SortDirection] {
        [.none, .ascend, .descend]
    }
}
