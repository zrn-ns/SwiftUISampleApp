//
//  RepositoryListViewModel.swift
//  App
//
//  Created by zrn_ns on 2022/08/16.
//

import APIClient
import Foundation

@MainActor
final class RepositoryListViewModel: ObservableObject {
    @Published private(set) var loadState: LoadState? = nil
    @Published private(set) var repositories: [MinimalRepository] = []
    @Published private(set) var user: User?

    @Published private(set) var userId: String?
    @Published private(set) var withoutFork: Bool?
    @Published private(set) var sortProperty: SortProperty?
    @Published private(set) var sortDirection: SortDirection?
    @Published private(set) var nextPagingParam: PagingParam?

    @Published private(set) var settings: UserSettings

    func viewWillAppear() {
        if userId != settings.userId
            || withoutFork != settings.withoutFork
            || sortProperty != settings.sortProperty
            || sortDirection != settings.sortDirection {
            // 設定が更新されていたらリロードをかける
            userId = settings.userId
            withoutFork = settings.withoutFork
            sortProperty = settings.sortProperty
            sortDirection = settings.sortDirection
            Task {
                await fetchAndReloadAll()
            }
        }
    }

    func fetchAndReloadAll() async {
        guard let userId,
              let withoutFork,
              let sortProperty,
              let sortDirection else { return }

        changeLoadStateSafety(loadState: .loading)
        self.nextPagingParam = nil

        do {
            async let repositoryListResponse = APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                            sortProperty: sortProperty,
                                                                                            sortDirection: sortDirection))
            async let userResponse = APIClient.sendAsync(GetUserRequest(userId: userId))

            let responses = try await (repos: repositoryListResponse, user: userResponse)

            changeLoadStateSafety(loadState: .normal)

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
            changeLoadStateSafety(loadState: .error(error))
            self.repositories = []
            self.user = nil
        } catch {
            preconditionFailure("本来侵入しない処理")
        }
    }

    func loadNextPage() async {
        guard let userId,
              let withoutFork,
              let sortProperty,
              let sortDirection,
              let nextPagingParam else { return }

        changeLoadStateSafety(loadState: .paging)

        do {
            let repositoryListResponse = try await APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                                sortProperty: sortProperty,
                                                                                                sortDirection: sortDirection,
                                                                                                pagingParam: nextPagingParam))

            changeLoadStateSafety(loadState: .normal)
            self.repositories = (self.repositories + repositoryListResponse.repositories).filter { repo in
                if withoutFork {
                    return !repo.isFork
                } else {
                    return true
                }
            }
            self.nextPagingParam = repositoryListResponse.nextPagingParam

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

    private func changeLoadStateSafety(loadState: LoadState) {
        guard self.loadState != loadState else { return }
        self.loadState = loadState
    }
}
