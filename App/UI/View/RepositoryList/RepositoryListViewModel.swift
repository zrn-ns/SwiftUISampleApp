//
//  RepositoryListViewModel.swift
//  App
//
//  Created by zrn_ns on 2022/08/16.
//

import APIClient
import SwiftUI

@MainActor
final class RepositoryListViewModel: ObservableObject {
    @Published private(set) var loadState: LoadState? = nil
    @Published private(set) var repositories: [MinimalRepository] = []
    @Published private(set) var user: User?

    #warning("private(set)にする")
    @Published var userId: String?
    @Published var withoutFork: Bool?
    @Published var sortProperty: SortProperty?
    @Published var sortDirection: SortDirection?
    @Published var nextPagingParam: PagingParam?

    @Published private(set) var settings: UserSettings

    func fetchAndReloadAll() async {
        guard let userId,
              let withoutFork,
              let sortProperty,
              let sortDirection else { return }

        changeLoadStateSafetyAnimated(loadState: .loading)
        self.nextPagingParam = nil

        do {
            async let repositoryListResponse = APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                            sortProperty: sortProperty,
                                                                                            sortDirection: sortDirection))
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

        changeLoadStateSafetyAnimated(loadState: .paging)

        do {
            let repositoryListResponse = try await APIClient.sendAsync(GetRepositoryListRequest(userId: userId,
                                                                                                sortProperty: sortProperty,
                                                                                                sortDirection: sortDirection,
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
        } catch {
            preconditionFailure("本来侵入しない処理")
        }
    }

    // MARK: - initializer

    init(settings: UserSettings) {
        self.settings = settings
    }

    // MARK: - private

    private func changeLoadStateSafetyAnimated(loadState: LoadState) {
        guard self.loadState != loadState else { return }

        #warning("SwiftUIのメソッドなのでView側に移動 & import SwiftUIを消す")
        withAnimation {
            self.loadState = loadState
        }
    }
}
