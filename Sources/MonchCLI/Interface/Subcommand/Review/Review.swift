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
            let service = makeService()

            let semaphore = DispatchSemaphore(value: 0)
            service.selectPullRequest() { pullRequests, requestedReviewers, authUser in
                let pullRequest = SelectView<PullRequest>(message: "PR を番号で選択してください",
                                                          items: pullRequests,
                                                          getTitleHandler: \.title).getItem()
                service.selectReviewer(for: pullRequest, with: requestedReviewers) { reviewerList, loginCountMap in
                    let reviewers = SelectView<Reviewer>(message: "レビュワーを選んでください",
                                                         hint: "(数字) は、その候補者が何本の PR をレビュー中かを表します",
                                                         items: reviewerList,
                                                         getTitleHandler: {
                                                            if let count = loginCountMap[$0.githubLogin] {
                                                                return "\($0.name) (\(count))"
                                                            } else {
                                                                return "\($0.name)"
                                                            }
                    }).getItems()
                    service.selectDeadline { deadlineList in
                        let deadline = SelectView<Deadline>(message: "しめ切りを設定してください",
                                                            items: deadlineList,
                                                            getTitleHandler: \.string).getItem()
                        service.requestReview(for: pullRequest, to: reviewers, by: deadline) {
                            print("タスクを振りました。")
                            semaphore.signal()
                        }
                    }
                }
            }
            semaphore.wait()
        }

        private func makeService() -> ReviewService {
            let option = ReviewService.Option(clearsCache: clearCache,
                                              showsAllPullRequests: showsAllPullRequests)
            let config = ConfigRepository().fetch()
            let gitHubClient = GithubClient(config: config.github)
            let chatworkClient = ChatworkClient(config: config.chatwork)
            return ReviewService(config: config,
                                 option: option,
                                 gitHubClient: gitHubClient,
                                 chatworkClient: chatworkClient)
        }
    }
}
