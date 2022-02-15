//
//  Review.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/07.
//

import Foundation
import ArgumentParser

extension Monch {
    struct Review: ParsableCommand, AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "PR のレビューを依頼する")

        @Flag(name: [.long, .customShort("c")], help: "GitHub ユーザーのキャッシュをクリアします")
        var clearCache: Bool = false

        @Flag(name: [.long, .customShort("a")], help: "すべての PR を表示します")
        var showsAllPullRequests: Bool = false

        mutating func runAsync() async throws {
            let service = makeService()

            // PR を選ぶ
            let (pullRequests, requestedReviewers, _) = await service.selectPullRequest()
            let pullRequest = SelectView<PullRequest>(message: "PR を番号で選択してください",
                                                      items: pullRequests,
                                                      getTitleHandler: \.title).getItem()
            // レビュワーを選ぶ
            let (reviewerList, loginCountMap) = service.selectReviewer(for: pullRequest, with: requestedReviewers)
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
            // タスクの締切を設定する
            let deadlineList = service.selectDeadline()
            let deadline = SelectView<Deadline>(message: "しめ切りを設定してください",
                                                items: deadlineList,
                                                getTitleHandler: \.string).getItem()
            // カスタムクエリーの問い合わせを行なう
            let customQueries = service.answerCustomQuery()
            let answers: [CustomQuery.Answer] = customQueries.map {
                TextReader<CustomQuery.Answer>(message: $0.message, completionHandler: $0.getAnswer(with:))
                    .read()
            }
            // Chatwork と GitHub にレビュー依頼を行なう
            await service.requestReview(for: pullRequest, to: reviewers, by: deadline, withCustomQueryAnswers: answers)
            print("タスクを振りました。")
            Monch.Review.exit(withError: nil)
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
