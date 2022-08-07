//
//  SettingsView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/31.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        Form {
            HStack() {
                Text(R.string.localizable.githubId())
                Spacer()
                TextField("zrn-ns", text: $settings.userId)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }.toolbar {
                Button(R.string.localizable.reset()) {
                    settings.reset()
                }
            }
        }.navigationTitle(R.string.localizable.settings())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(settings: UserSettings.sharedForPreview)
        }
    }
}
