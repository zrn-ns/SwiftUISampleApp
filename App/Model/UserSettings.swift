//
//  UserSettings.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/31.
//

import APIClient
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
    /// ソート順を決めるためのプロパティ
    @Published var sortProperty: SortProperty {
        didSet {
            userDefaults.setValue(sortProperty.rawValue, forKey: "sortProperty")
        }
    }

    func reset() {
        self.userId = ""
        self.withoutFork = false
        self.sortProperty = .fullName
    }

    // MARK: - private

    fileprivate init(suiteName: String? = nil) {
        self.suiteName = suiteName ?? Bundle.main.bundleIdentifier!
        userDefaults = .init(suiteName: suiteName)!
        self.userId = userDefaults.value(forKey: "userId") as? String ?? ""
        self.withoutFork = userDefaults.value(forKey: "withoutFork") as? Bool ?? false
        if let sortPropertyStr = userDefaults.value(forKey: "sortProperty") as? String,
           let sortProperty: SortProperty = .init(rawValue: sortPropertyStr) {
            self.sortProperty = sortProperty
        } else {
            self.sortProperty = .fullName
        }
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
