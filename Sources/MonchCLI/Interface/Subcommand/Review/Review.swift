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
        var clearCache: Bool = false

        @Flag(name: [.long, .customShort("a")], help: "すべての PR を表示します")
        var showsAllPullRequests: Bool = false

        mutating func run() {
            let config = ConfigRepository().fetch()
            let option = ReviewService.Option(clearsCache: clearCache,
                                              showsAllPullRequests: showsAllPullRequests)
            let service: ReviewService = { config, option in
                let gitHubClient = GithubClient(config: config.github)
                let chatworkClient = ChatworkClient(config: config.chatwork)
                return ReviewService(config: config,
                                     option: option,
                                     gitHubClient: gitHubClient,
                                     chatworkClint: chatworkClient)
            }(config, option)

            let semaphore = DispatchSemaphore(value: 0)
            service.selectPullRequest() { [self] pullRequests, authUser in
                let pullRequest = SelectView<PullRequest>(message: "PR を番号で選択してください",
                                                          items: pullRequests,
                                                          getTitleHandler: \.title).getItem()
                self.requestCodeReview(for: pullRequest, with: config) {
                    print("タスクを振りました。")
                    semaphore.signal()
                }
            }
            semaphore.wait()
        }

        private func requestCodeReview(for pullRequest: PullRequest, with config: Config, completionHandler: @escaping () -> Void) {
            let filteredReviewers = config.reviewers
                .filter(Reviewer.isReviewable(with: pullRequest))
            let reviewers = SelectView<Reviewer>(message: "レビュワーを選んでください",
                                                 items: filteredReviewers,
                                                 getTitleHandler: \.name).getItems()

            let text = """
            \(pullRequest.title)
            \(pullRequest.htmlUrl)

            レビューをお願いします (please)
            """

            let deadline = SelectView<Deadline>(message: "しめ切りを設定してください",
                                                items: Deadline.allCases,
                                                getTitleHandler: \.string).getItem()
            guard let deadlineDate = deadline.getDate() else { return }

            //        let request = CreateMessageRequest(roomId: config.chatwork.roomId, text: "Hello, This is MonchCLI!")
            let request = CreateTaskRequest(roomId: config.chatwork.roomId, text: text, assigneeIds: reviewers.map(\.chatworkId), limitType: .date, deadline: deadlineDate)
            let chatworkClient = ChatworkClient(config: config.chatwork)
            chatworkClient.send(request) { taskResponse in
                let request = CreateReviewRequestRequest(
                    repository: config.github.repository,
                    pullRequestId: pullRequest.number,
                    reviewers: reviewers.map(\.githubLogin)
                )
                let githubClient = GithubClient(config: config.github)
                githubClient.send(request) { pullRequest in
                    completionHandler()
                }
            }
        }
    }
}
