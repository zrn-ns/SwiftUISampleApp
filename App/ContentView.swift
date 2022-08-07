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

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(R.color.contentBase.color)
                Text("Hello, world!")

                #warning("デバッグ実装")
                Button("Send Request") {
                    Task {
                        let result = await APIClient.send(GetRepositoryListRequest(userId: settings.userId))
                        switch result {
                        case .success(let success):
                            print(success)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }

            }.toolbar {
                NavigationLink(destination: SettingsView(settings: settings), label: {
                    Image(systemName: "gearshape")
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: UserSettings.sharedForPreview)
    }
}
