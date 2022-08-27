//
//  GithubRepositoryListViewModel.swift
//  App
//
//  Created by zrn_ns on 2022/08/16.
//

import APIClient
import Foundation

// MARK: - protocol

@MainActor
protocol GithubRepositoryListViewModel: ObservableObject {
    var loadState: LoadState? { get }
    var repositories: [MinimalGithubRepository] { get }
    var user: User? { get }

    func viewWillAppear()
    func shouldShowPagingView() -> Bool
    func fetchAndReloadAll() async
    func loadNextPage() async
}

// MARK: - Impl

@MainActor
final class GithubRepositoryListViewModelImpl: GithubRepositoryListViewModel {
    @Published private(set) var loadState: LoadState? = nil
    @Published private(set) var repositories: [MinimalGithubRepository] = []
    @Published private(set) var user: User?

    func viewWillAppear() {
        searchParams = .init(userId: settings.userId,
                             withoutFork: settings.withoutFork,
                             sortProperty: settings.sortProperty,
                             sortDirection: settings.sortDirection)
    }

    func shouldShowPagingView() -> Bool {
        if let nextPagingParam,
           nextPagingParam.hasNextPage {
            return true
        }

        return false
    }

    func fetchAndReloadAll() async {
        guard let searchParams else { return }

        changeLoadStateSafety(loadState: .loading)
        nextPagingParam = nil

        do {
            #warning("APIClientはモックに差し替えられるようにしたい")
            async let githubRepositoryListResponse = APIClient.sendAsync(GetGithubRepositoryListRequest(userId: searchParams.userId,
                                                                                                        sortProperty: searchParams.sortProperty,
                                                                                                        sortDirection: searchParams.sortDirection))
            async let userResponse = APIClient.sendAsync(GetUserRequest(userId: searchParams.userId))

            let responses = try await (repos: githubRepositoryListResponse, user: userResponse)

            changeLoadStateSafety(loadState: .normal)

            repositories = responses.repos.repositories.filter { repo in
                if searchParams.withoutFork {
                    return !repo.isFork
                } else {
                    return true
                }
            }
            user = responses.user
            nextPagingParam = responses.repos.nextPagingParam

        } catch let error as APIError {
            changeLoadStateSafety(loadState: .error(error))
            self.repositories = []
            self.user = nil
        } catch {
            preconditionFailure("本来侵入しない処理")
        }
    }

    func loadNextPage() async {
        guard let searchParams,
              let nextPagingParam else { return }

        changeLoadStateSafety(loadState: .paging)

        do {
            let githubRepositoryListResponse = try await APIClient.sendAsync(GetGithubRepositoryListRequest(userId: searchParams.userId,
                                                                                                            sortProperty: searchParams.sortProperty,
                                                                                                            sortDirection: searchParams.sortDirection,
                                                                                                            pagingParam: nextPagingParam))

            changeLoadStateSafety(loadState: .normal)
            repositories = (repositories + githubRepositoryListResponse.repositories).filter { repo in
                if searchParams.withoutFork {
                    return !repo.isFork
                } else {
                    return true
                }
            }
            self.nextPagingParam = githubRepositoryListResponse.nextPagingParam

        } catch let error as APIError {
            changeLoadStateSafety(loadState: .error(error))
            self.repositories = []
        } catch {
            preconditionFailure("本来侵入しない処理")
        }
    }

    // MARK: - initializer

    init(settings: UserSettings) {
        self.settings = settings
    }

    // MARK: - private

    private var settings: UserSettings
    private var nextPagingParam: PagingParam?

    /// 検索条件
    private var searchParams: SearchParams? {
        didSet {
            if searchParams != oldValue {
                // 検索条件が更新されていたらリロードをかける
                Task {
                    await fetchAndReloadAll()
                }
            }
        }
    }

    private func changeLoadStateSafety(loadState: LoadState) {
        guard self.loadState != loadState else { return }
        self.loadState = loadState
    }
}

// MARK: - SearchParams

private struct SearchParams: Equatable {
    var userId: String
    var withoutFork: Bool
    var sortProperty: SortProperty
    var sortDirection: SortDirection
}
