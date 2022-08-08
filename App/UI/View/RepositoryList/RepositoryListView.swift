//
//  RepositoryListView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import APIClient
import SwiftUI

struct RepositoryListView: View {
    @ObservedObject var settings: UserSettings
    @State var loadState: LoadState? = nil

    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .none:
                    // NOTE: EmptyViewでもよさそうだが、onAppearが呼ばれなくなってしまったのでVStackを使っている
                    VStack {}
                        .onAppear {
                            reloadData()
                        }

                case .normal:
                    #warning("書き換え予定")
                    Button("Load completed") {
                        reloadData()
                    }
                case .loading:
                    ProgressView(Localizable.loading())

                case .error(let apiError):
                    #warning("表示用のメッセージを出すように修正")
                    ReloadableErrorView(errorMessage: apiError.localizedDescription) {
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
            changeLoadStateSafetyAnimated(loadState: .loading)

            let result = await APIClient.send(GetRepositoryListRequest(userId: settings.userId))
            switch result {
            case .success(let success):
                changeLoadStateSafetyAnimated(loadState: .normal)
                print(success)
            case .failure(let failure):
                changeLoadStateSafetyAnimated(loadState: .error(failure))
            }
        }
    }

    private func changeLoadStateSafetyAnimated(loadState: LoadState) {
        guard self.loadState != loadState else { return }

        withAnimation {
            self.loadState = loadState
        }
    }
}

struct RepositoryLostView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(settings: UserSettings.sharedForPreview)
    }
}