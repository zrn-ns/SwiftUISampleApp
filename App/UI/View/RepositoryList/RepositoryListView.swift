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
    @State var nextPagingParam: PagingParam?

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
                        if let nextPagingParam,
                           nextPagingParam.hasNextPage {
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
            self.nextPagingParam = nil

            do {
                async let repositoryListResponse = APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                      sortProperty: sortProperty))
                async let userResponse = APIClient.sendAsync(GetUserRequest(userId: userId))

                let responses = try await (repos: repositoryListResponse, user: userResponse)

                changeLoadStateSafetyAnimated(loadState: .normal)

                self.repositories = responses.repos.repositories.filter { repo in
                    if withoutFork {
                        return !repo.isFork
                    } else {
                        return true
                    }
                }
                self.user = responses.user
                self.nextPagingParam = responses.repos.nextPagingParam

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
                  let nextPagingParam else { return }

            changeLoadStateSafetyAnimated(loadState: .paging)

            do {
                let repositoryListResponse = try await APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                                    sortProperty: sortProperty,
                                                                                                    pagingParam: nextPagingParam))

                changeLoadStateSafetyAnimated(loadState: .normal)
                self.repositories = (self.repositories + repositoryListResponse.repositories).filter { repo in
                    if withoutFork {
                        return !repo.isFork
                    } else {
                        return true
                    }
                }
                self.nextPagingParam = repositoryListResponse.nextPagingParam

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
