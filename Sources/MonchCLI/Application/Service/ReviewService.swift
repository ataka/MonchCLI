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

    func selectPullRequest() async -> (pullRequests: ArraySlice<PullRequest>, requestedReviewers: [GitHubUser], authUser: GitHubUser) {
        let authUser = await getAuthenticatedUser(clearsCache: option.clearsCache)
        let request = ListPullRequestsRequest(config: self.config.github)
        let pullRequests = await gitHubClient.send(request)
        let filteredPullRequests = pullRequests
            .filter(PullRequest.isListable(showsAll: self.option.showsAllPullRequests, authenticatedUser: authUser))
            .prefix(8)
        let requestedReviewers = pullRequests.flatMap(\.requestedReviewers)

        return (pullRequests: filteredPullRequests, requestedReviewers: requestedReviewers, authUser: authUser)
    }

    private func getAuthenticatedUser(clearsCache: Bool) async -> GitHubUser {
        let repository = GitHubAuthUserRepository()
        if clearsCache {
            repository.delete()
        }

        guard let authUser = repository.fetch() else {
            let request = GetAuthenticatedUserRequest()
            let authUser = await gitHubClient.send(request)
            repository.save(authUser)
            return authUser
        }
        return authUser
    }

    // MARK: Select Reviewer

    func selectReviewer(for pullRequest: PullRequest, with requestedReviewers: [GitHubUser]) -> (reviewers: [Reviewer], loginCountMap: [GitHub.Login: Int]) {
        let filteredReviewers = config.reviewers
            .filter(Reviewer.isReviewable(with: pullRequest))
        let loginCountMap: [GitHub.Login: Int] = requestedReviewers
            .reduce(into: [GitHub.Login: Int]()) { $0[$1.login, default: 0] += 1 }

        return(reviewers: filteredReviewers, loginCountMap: loginCountMap)
    }

    // MARK: Select Deadline

    func selectDeadline() -> [Deadline] {
        Deadline.allCases
    }

    // MARK: Answer Custom Query

    func answerCustomQuery() -> [CustomQuery] {
        config.customQueries
    }

    // MARK: Request Review

    func requestReview(for pullRequest: PullRequest, to reviewers: [Reviewer], by deadline: Deadline, withCustomQueryAnswers answers: [CustomQuery.Answer]) async {
        guard let deadlineDate = deadline.getDate() else { fatalError() }
        let text = makeTaskText(pullRequest: pullRequest, answers: answers)
        let chatworkRoomIdMap: [Chatwork.RoomId: [Reviewer]] = Dictionary(grouping: reviewers) {
            $0.chatworkRoomId ?? config.chatwork.roomId
        }
        for (chatworkRoomId, assignees) in chatworkRoomIdMap {
            let request = CreateTaskRequest(roomId: chatworkRoomId,
                                            text: text,
                                            assigneeIds: assignees.map(\.chatworkId),
                                            limitType: .date,
                                            deadline: deadlineDate)
            _ = await chatworkClient.send(request)
        }

        // Create ReviewRequest for GitHub
        let request = CreateReviewRequestRequest(repository: config.github.repository,
                                                 pullRequestId: pullRequest.number,
                                                 reviewers: reviewers.map(\.githubLogin))
        _ = await gitHubClient.send(request)
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
