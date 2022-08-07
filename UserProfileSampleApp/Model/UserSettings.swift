//
//  UserSettings.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/31.
//

import Foundation

final class UserSettings: ObservableObject {
    static let shared: UserSettings = .init()

    @Published var userId: String {
        didSet {
            userDefaults.setValue(userId, forKey: "userId")
        }
    }

    func reset() {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    // MARK: - private

    fileprivate init(suiteName: String? = nil) {
        self.suiteName = suiteName ?? Bundle.main.bundleIdentifier!
        userDefaults = .init(suiteName: suiteName)!
        self.userId = userDefaults.value(forKey: "userId") as? String ?? ""
    }

    private var userDefaults: UserDefaults
    private var suiteName: String
}

#if DEBUG
extension UserSettings {
    static let sharedForPreview: UserSettings = {
        return .init(suiteName: "suiteForPreview")
    }()
}
#endif
