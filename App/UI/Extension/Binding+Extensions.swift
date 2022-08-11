//
//  Binding+Extensions.swift
//  App
//
//  Created by zrn_ns on 2022/08/11.
//

import Foundation
import SwiftUI

extension Binding {
    func unwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
