//
//  SortProperty+Extension.swift
//  App
//
//  Created by zrn_ns on 2022/08/12.
//

import APIClient
import Foundation

extension SortProperty {
    public func pickerText() -> String {
        switch self {
        case .fullName:
            return Localizable.sortPropertyFullName()
        case .createdAt:
            return Localizable.sortPropertyCreatedAt()
        case .updatedAt:
            return Localizable.sortPropertyUpdatedAt()
        case .pushedAt:
            return Localizable.sortPropertyPushedAt()
        }
    }
}
