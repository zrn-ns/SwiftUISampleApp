//
//  ContentView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.contentColor(.base))
                Text("Hello, world!")
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
