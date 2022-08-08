//
//  RepositoryListView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import APIClient
import SwiftUI

struct RepositoryListView: View {
    #warning("設定されたユーザIDが変化していたら、リロードをかける")
    @ObservedObject var settings: UserSettings
    @State var loadState: LoadState? = nil
    @State var repositories: [MinimalRepository] = []

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
                    List(repositories) { repo in
                        NavigationLink {
                            WebView(url: URL(string: repo.htmlUrl)!)
                        } label: {
                            RepositoryListItemView(repository: repo)
                        }
                    }.listStyle(.plain)
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
                #warning("リロードボタンを付ける")
            }
        }
    }

    private func reloadData() {
        Task {
            changeLoadStateSafetyAnimated(loadState: .loading)

            #warning("ユーザの詳細も一緒に取得し、画面のタイトルにユーザの情報を表示する")
            #warning("ページングを実装")
            let result = await APIClient.send(GetRepositoryListRequest(userId: settings.userId))
            switch result {
            case .success(let response):
                changeLoadStateSafetyAnimated(loadState: .normal)
                repositories = response
            case .failure(let error):
                changeLoadStateSafetyAnimated(loadState: .error(error))
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
