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

    #warning("更新条件が増えてきて管理しづらくなってきたので、まとめる")
    @State var userId: String?
    @State var withoutFork: Bool?
    @State var sortProperty: SortProperty?
    #warning("Pagingに関する情報は一つのモデルに押し込める気がする")
    @State var currentPage: Int?
    @State var existsNextPage: Bool = false

    @State var repositories: [MinimalRepository] = []
    @State var user: User?

    var body: some View {
        NavigationView {
            VStack {
                switch loadState {
                case .none:
                    EmptyView()

                case .normal, .paging:
                    List {
                        Section {
                            ForEach(repositories) { repo in
                                NavigationLink {
                                    WebView(url: repo.htmlUrl)
                                } label: {
                                    RepositoryListItemView(repository: repo)
                                }
                            }
                        }
                        if existsNextPage {
                            Section {
                                PagingView()
                                    .onAppear {
                                        loadNextPage()
                                    }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        guard let loadState,
                              loadState.isNotFetching() else { return }
                        fetchAndReloadAll()
                    }

                case .loading:
                    ProgressView(Localizable.loading())

                case .error(let apiError):
                    #warning("表示用のメッセージを出すように修正")
                    ReloadableErrorView(errorMessage: apiError.localizedDescription) {
                        fetchAndReloadAll()
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
                if self.userId != settings.userId
                    || self.withoutFork != settings.withoutFork
                    || self.sortProperty != settings.sortProperty {
                    // 設定が更新されていたらリロードをかける
                    self.userId = settings.userId
                    self.withoutFork = settings.withoutFork
                    self.sortProperty = settings.sortProperty
                    fetchAndReloadAll()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - private

    private func fetchAndReloadAll() {
        Task {
            guard let userId,
                  let withoutFork,
                  let sortProperty else { return }

            changeLoadStateSafetyAnimated(loadState: .loading)
            self.currentPage = nil
            self.existsNextPage = false

            do {
                async let repositories = APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                      sortProperty: sortProperty,
                                                                                      currentPage: currentPage))
                async let user = APIClient.sendAsync(GetUserRequest(userId: userId))

                let allResponses = try await (repos: repositories, user: user)

                changeLoadStateSafetyAnimated(loadState: .normal)

                self.repositories = allResponses.repos.filter { repo in
                    if withoutFork {
                        return !repo.isFork
                    } else {
                        return true
                    }
                }
                self.user = allResponses.user
                self.currentPage = 1
                self.existsNextPage = !allResponses.repos.isEmpty

            } catch let error as APIError {
                changeLoadStateSafetyAnimated(loadState: .error(error))
                self.repositories = []
                self.user = nil
            }
        }
    }

    private func loadNextPage() {
        Task {
            guard let userId,
                  let withoutFork,
                  let sortProperty,
                  let currentPage else { return }

            changeLoadStateSafetyAnimated(loadState: .paging)

            do {
                let repositories = try await APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                          sortProperty: sortProperty,
                                                                                          currentPage: currentPage))

                changeLoadStateSafetyAnimated(loadState: .normal)
                self.repositories = (self.repositories + repositories).filter { repo in
                    if withoutFork {
                        return !repo.isFork
                    } else {
                        return true
                    }
                }
                self.currentPage = currentPage + 1
                self.existsNextPage = !repositories.isEmpty

            } catch let error as APIError {
                changeLoadStateSafetyAnimated(loadState: .error(error))
                self.repositories = []
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
