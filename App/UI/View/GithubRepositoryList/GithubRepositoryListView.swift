//
//  GithubRepositoryListView.swift
//  UserProfileSampleApp
//
//  Created by zrn_ns on 2022/07/30.
//

import APIClient
import SwiftUI

struct GithubRepositoryListView<ViewModel: GithubRepositoryListViewModel>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.loadState {
                case .none:
                    EmptyView()

                case .normal, .paging:
                    List {
                        Section {
                            ForEach(viewModel.repositories) { repo in
                                NavigationLink {
                                    WebView(url: repo.htmlUrl)
                                } label: {
                                    GithubRepositoryListItemView(githubRepository: repo)
                                }
                            }
                        }
                        if viewModel.shouldShowPagingView() {
                            Section {
                                PagingView()
                                    .task {
                                        await viewModel.loadNextPage()
                                    }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        guard let loadState = viewModel.loadState,
                              loadState.isNotFetching() else { return }
                        await viewModel.fetchAndReloadAll()
                    }

                case .loading:
                    ProgressView(Localizable.loading())

                case .error(let apiError):
                    ReloadableErrorView(errorMessage: apiError.presentableErrorMessage()) {
                        Task {
                            await viewModel.fetchAndReloadAll()
                        }
                    }
                }

            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(settings: UserSettings.shared), label: {
                        Image(systemName: "gearshape")
                    })
                }
                ToolbarItem(placement: .principal) {
                    UserInfoNavigationItemView(userIconURL: viewModel.user?.avatarUrl,
                                               userName: viewModel.user?.login)
                }

            }.task {
                viewModel.viewWillAppear()
            }
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: viewModel.loadState)
        }
    }
}

struct GithubRepositoryLostView_Previews: PreviewProvider {
    static var previews: some View {
        GithubRepositoryListView(viewModel: GithubRepositoryListViewModelImpl(settings: .sharedForPreview))
    }
}
