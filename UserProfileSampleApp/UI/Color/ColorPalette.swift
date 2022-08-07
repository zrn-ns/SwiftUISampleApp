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

enum ContentColor {
    case base

    func toUIColor() -> UIColor {
        switch self {
        case .base:
            return .init { trait in
                var light: UIColor { .init(hex: 0xFDC44F) }
                var dark: UIColor { .init(hex: 0xFCB119) }

                switch trait.userInterfaceStyle {
                case .light, .unspecified: return light
                case .dark: return dark
                @unknown default: return light
                }
            }
        }
    }
}

// MARK: - SwiftUI.Color extension

extension Color {
    /// 文字色
    static func typoColor(_ typoColor: TypoColor) -> Color {
        Color(typoColor.toUIColor())
    }
    /// アイコン、コンテンツで使う色
    static func contentColor(_ contentColor: ContentColor) -> Color {
        Color(contentColor.toUIColor())
    }
}

// MARK: - UIColor extension

extension UIColor {
    convenience init(hex: UInt64) {
        let divisor = Double(255)
        let alpha = Double(1 - 1 / divisor)
        let red = Double((hex & 0xFF0000) >> 16) / divisor
        let green = Double((hex & 0x00FF00) >> 8) / divisor
        let blue = Double(hex & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

