//
//  Review.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation
import ArgumentParser

extension Monch {
    struct Review: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "PR のレビューを依頼する")

        @Flag(name: [.long, .customShort("c")], help: "GitHub ユーザーのキャッシュをクリアします")
        var clearCache: Bool

        @Flag(name: [.long, .customShort("a")], help: "すべての PR を表示します")
        var showsAllPullRequests: Bool

        mutating func run() {
            let config = ConfigRepository().fetch()

            let semaphore = DispatchSemaphore(value: 0)
            selectPullRequests(with: config) { [self] pullRequest in
                self.requestCodeReview(for: pullRequest, with: config) {
                    print("タスクを振りました。")
                    semaphore.signal()
                }
            }
            semaphore.wait()
        }

        private func selectPullRequests(with config: Config, completionHandler: @escaping (PullRequest) -> Void) {
            let githubClient = GithubClient(config: config.github)
            getAuthenticatedUser(client: githubClient) { authUser in
                let request = ListPullRequestsRequest(config: config.github)
                githubClient.send(request) { pullRequests in
                    let selectedPullRequests = pullRequests
                        .filter(PullRequest.isListable(showsAll: self.showsAllPullRequests, authenticatedUser: authUser))
                        .prefix(8)

                    let pullRequest = SelectView<PullRequest>(message: "PR を番号で選択してください",
                                                              items: selectedPullRequests,
                                                              getTitleHandler: { $0.title }).getItem()
                    completionHandler(pullRequest)
                }
            }
        }

        private func getAuthenticatedUser(client: GithubClient, completionHandler: @escaping (GitHubUser) -> Void) {
            let repository = GitHubAuthUserRepository()
            if clearCache {
                repository.delete()
            }

            guard let authUser = repository.fetch() else {
                let request = GetAuthenticatedUserRequest()
                client.send(request) { authUser in
                    repository.save(authUser)
                    completionHandler(authUser)
                }
                return
            }
            completionHandler(authUser)
        }

        private func requestCodeReview(for pullRequest: PullRequest, with config: Config, completionHandler: @escaping () -> Void) {
            let selectedReviewers = config.reviewers
                .filter(Reviewer.isReviewable(with: pullRequest))
            let reviewers = SelectView<Reviewer>(message: "レビュワーを選んでください",
                                                 items: selectedReviewers,
                                                 getTitleHandler: { $0.name }).getItems()

            let text = """
            \(pullRequest.title)
            \(pullRequest.htmlUrl)

            レビューをお願いします (please)
            """

            let deadline = SelectView<Deadline>(message: "しめ切りを設定してください",
                                                items: Deadline.allCases,
                                                getTitleHandler: { $0.string }).getItem()
            guard let deadlineDate = deadline.getDate() else { return }

            //        let request = CreateMessageRequest(roomId: config.chatwork.roomId, text: "Hello, This is MonchCLI!")
            let request = CreateTaskRequest(roomId: config.chatwork.roomId, text: text, assigneeIds: reviewers.map { $0.chatworkId}, limitType: .date, deadline: deadlineDate)
            let chatworkClient = ChatworkClient(config: config.chatwork)
            chatworkClient.send(request) { taskResponse in
                let request = CreateReviewRequestRequest(
                    repository: config.github.repository,
                    pullRequestId: pullRequest.number,
                    reviewers: reviewers.map { $0.githubLogin }
                )
                let githubClient = GithubClient(config: config.github)
                githubClient.send(request) { pullRequest in
                    completionHandler()
                }
            }
        }
    }
}
