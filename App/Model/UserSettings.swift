//
//  UserSettings.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/31.
//

import Foundation

final class UserSettings: ObservableObject {
    static let shared: UserSettings = .init()

    /// GithubのユーザID
    @Published var userId: String {
        didSet {
            userDefaults.setValue(userId, forKey: "userId")
        }
    }
    /// forkされたリポジトリは除外する
    @Published var withoutFork: Bool {
        didSet {
            userDefaults.setValue(withoutFork, forKey: "withoutFork")
        }
    }

    func reset() {
        self.userId = ""
        self.withoutFork = false
    }

    // MARK: - private

    fileprivate init(suiteName: String? = nil) {
        self.suiteName = suiteName ?? Bundle.main.bundleIdentifier!
        userDefaults = .init(suiteName: suiteName)!
        self.userId = userDefaults.value(forKey: "userId") as? String ?? ""
        self.withoutFork = userDefaults.value(forKey: "withoutFork") as? Bool ?? false
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
