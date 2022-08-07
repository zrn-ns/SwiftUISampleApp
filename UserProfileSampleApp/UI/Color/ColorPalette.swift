//
//  ColorPalette.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import Foundation
import SwiftUI
import UIKit

enum TypoColor {
    case heavy
    case normal
    case lighter
    case lightest

    func toUIColor() -> UIColor {
        switch self {
        case .heavy:
            return .label
        case .normal:
            return .secondaryLabel
        case .lighter:
            return .tertiaryLabel
        case .lightest:
            return .quaternaryLabel
        }
    }
}

// MARK: - SwiftUI.Color extension

extension Color {
    /// 文字色
    static func typoColor(_ typoColor: TypoColor) -> Color {
        Color(typoColor.toUIColor())
    }
}
