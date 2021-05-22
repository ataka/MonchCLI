//
//  ReviewService.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/27.
//

import Foundation

struct ReviewService {
    struct Option {
        let clearsCache: Bool
        let showsAllPullRequests: Bool
    }

    let config: Config
    let option: Option
    let gitHubClient: GithubClient
    let chatworkClient: ChatworkClient

    // MARK: Select Pull Request

    func selectPullRequest(completionHandler: @escaping (_ pullRequests: ArraySlice<PullRequest>, _ requestedReviewers: [GitHubUser], _ authUser: GitHubUser) -> Void) {
        getAuthenticatedUser(clearsCache: option.clearsCache) { authUser in
            let request = ListPullRequestsRequest(config: self.config.github)
            self.gitHubClient.send(request) { pullRequests in
                let filteredPullRequests = pullRequests
                    .filter(PullRequest.isListable(showsAll: self.option.showsAllPullRequests, authenticatedUser: authUser))
                    .prefix(8)
                let requestedReviewers = pullRequests.flatMap(\.requestedReviewers)

                completionHandler(filteredPullRequests, requestedReviewers, authUser)
            }
        }
    }

    private func getAuthenticatedUser(clearsCache: Bool, completionHandler: @escaping (GitHubUser) -> Void) {
        let repository = GitHubAuthUserRepository()
        if clearsCache {
            repository.delete()
        }

        guard let authUser = repository.fetch() else {
            let request = GetAuthenticatedUserRequest()
            gitHubClient.send(request) { authUser in
                repository.save(authUser)
                completionHandler(authUser)
            }
            return
        }
        completionHandler(authUser)
    }

    // MARK: Select Reviewer

    func selectReviewer(for pullRequest: PullRequest, with requestedReviewers: [GitHubUser], completionHandler: (_ reviewers: [Reviewer], _ loginCountMap: [GitHubLogin: Int]) -> Void) {
        let filteredReviewers = config.reviewers
            .filter(Reviewer.isReviewable(with: pullRequest))
        let loginCountMap: [GitHubLogin: Int] = requestedReviewers
            .reduce(into: [GitHubLogin: Int]()) { $0[$1.login, default: 0] += 1 }

        completionHandler(filteredReviewers, loginCountMap)
    }

    // MARK: Select Deadline

    func selectDeadline(completionHandler: (_ deadlines: [Deadline]) -> Void) {
        completionHandler(Deadline.allCases)
    }

    // MARK: Answer Custom Query

    func answerCustomQuery(completionHandler: (_ customQueries: [CustomQuery]) -> Void) {
        completionHandler(config.customQueries)
    }

    // MARK: Request Review

    func requestReview(for pullRequest: PullRequest, to reviewers: [Reviewer], by deadline: Deadline, withCustomQueryAnswers answers: [CustomQuery.Answer], completionHandler: @escaping () -> Void) {
        guard let deadlineDate = deadline.getDate() else { fatalError() }
        let text = makeTaskText(pullRequest: pullRequest, answers: answers)
        let chatworkRoomIdMap: [Chatwork.RoomId: [Reviewer]] = Dictionary(grouping: reviewers) {
            $0.chatworkRoomId ?? config.chatwork.roomId
        }
        let group = DispatchGroup()
        for (chatworkRoomId, assignees) in chatworkRoomIdMap {
            group.enter()
            let request = CreateTaskRequest(roomId: chatworkRoomId,
                                            text: text,
                                            assigneeIds: assignees.map(\.chatworkId),
                                            limitType: .date,
                                            deadline: deadlineDate)
            chatworkClient.send(request) { _ in
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) { [self] in
            // Create ReviewRequest for GitHub
            let request = CreateReviewRequestRequest(repository: config.github.repository,
                                                     pullRequestId: pullRequest.number,
                                                     reviewers: reviewers.map(\.githubLogin))
            gitHubClient.send(request) { pullRequest in
                completionHandler()
            }
        }
    }

    private func makeTaskText(pullRequest: PullRequest, answers: [CustomQuery.Answer]) -> String {
        if answers.isEmpty {
            return """
            \(pullRequest.title)
            \(pullRequest.htmlUrl)

            レビューをお願いします (please)
            """
        } else {
            return """
            \(pullRequest.title)
            \(pullRequest.htmlUrl)

            \(answers.map(\.rawValue).joined(separator: "\n"))

            レビューをお願いします (please)
            """
        }
    }
}
