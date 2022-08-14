//
//  SettingsView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/31.
//

import APIClient
import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        Form {
            HStack() {
                Text(Localizable.githubId())
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                TextField("zrn-ns", text: $settings.userId)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .foregroundColor(R.color.typoNormal.color)
            }
            HStack() {
                Text(Localizable.withoutFork())
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                Toggle("", isOn: $settings.withoutFork)
            }
            HStack() {
                Text(Localizable.sortProperty())
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                Picker("", selection: $settings.sortProperty) {
                    ForEach(SortProperty.allCases, id: \.self) { prop in
                        Text(prop.pickerText())
                    }
                }
            }
            HStack() {
                Text(Localizable.sortDirection())
                    .foregroundColor(R.color.typoNormal.color)
                Spacer()
                Picker("", selection: $settings.sortDirection) {
                    ForEach(SortDirection.pickerSelections(), id: \.self) { prop in
                        Text(prop.pickerText())
                    }
                }
            }
            .toolbar {
                Button(Localizable.reset()) {
                    settings.reset()
                }
            }
        }.navigationTitle(Localizable.settings())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(settings: UserSettings.sharedForPreview)
        }
    }
}
