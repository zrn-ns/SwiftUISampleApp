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
    @State var userId: String?
    #warning("Forkをfilterできるようにする")
    @State var repositories: [MinimalRepository] = []
    @State var user: User?

    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .none:
                    EmptyView()

                case .normal:
                    List(repositories) { repo in
                        NavigationLink {
                            WebView(url: repo.htmlUrl)
                        } label: {
                            RepositoryListItemView(repository: repo)
                        }
                    }.listStyle(.plain)
                        .refreshable { reloadData() }
                case .loading:
                    ProgressView(Localizable.loading())

                case .error(let apiError):
                    #warning("表示用のメッセージを出すように修正")
                    ReloadableErrorView(errorMessage: apiError.localizedDescription) {
                        reloadData()
                    }
                }

            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(settings: settings), label: {
                        Image(systemName: "gearshape")
                    })
                }
                ToolbarItem(placement: .principal) {
                    UserInfoNavigationItemView(userIconURL: user?.avatarUrl,
                                               userName: user?.login)
                }

            }.onAppear {
                if self.userId != settings.userId {
                    // userIdが変化していたら、リロードをかける
                    self.userId = settings.userId
                    reloadData()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - private

    private func reloadData() {
        Task {
            guard let userId else { return }

            changeLoadStateSafetyAnimated(loadState: .loading)

            #warning("ページングを実装")
            do {
                async let repositories = APIClient.sendAsync(GetRepositoryListRequest(userId: userId))
                async let user = APIClient.sendAsync(GetUserRequest(userId: userId))

                changeLoadStateSafetyAnimated(loadState: .normal)
                self.repositories = try await repositories
                self.user = try await user

            } catch let error as APIError {
                changeLoadStateSafetyAnimated(loadState: .error(error))
                self.repositories = []
                self.user = nil
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
