//
//  Rswift+Extensions.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/08/07.
//

import Foundation
import Rswift
import SwiftUI

extension Rswift.ColorResource {
    var color: Color {
        Color(name, bundle: bundle)
    }
}
