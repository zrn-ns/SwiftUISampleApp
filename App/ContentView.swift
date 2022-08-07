//
//  ContentView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import APIClient
import SwiftUI

struct ContentView: View {
    @ObservedObject var settings: UserSettings
    @State var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage {
                    ReloadableErrorView(errorMessage: errorMessage) {
                        reloadData()
                    }
                } else {
                    #warning("書き換え予定")
                    Button("Send Request") {
                        reloadData()
                    }
                }

            }.toolbar {
                NavigationLink(destination: SettingsView(settings: settings), label: {
                    Image(systemName: "gearshape")
                })
            }
        }
    }

    private func reloadData() {
        Task {
            let result = await APIClient.send(GetRepositoryListRequest(userId: settings.userId))
            switch result {
            case .success(let success):
                #warning("リストに反映")
                print(success)
            case .failure(let failure):
                errorMessage = failure.localizedDescription
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: UserSettings.sharedForPreview)
    }
}
