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
    let chatworkClint: ChatworkClient

    func selectPullRequest(completionHandler: @escaping (_ pullRequests: ArraySlice<PullRequest>, _ authUser: GitHubUser) -> Void) {
        getAuthenticatedUser(clearsCache: option.clearsCache) { authUser in
            let request = ListPullRequestsRequest(config: self.config.github)
            self.gitHubClient.send(request) { pullRequests in
                let filteredPullRequests = pullRequests
                    .filter(PullRequest.isListable(showsAll: self.option.showsAllPullRequests, authenticatedUser: authUser))
                    .prefix(8)

                completionHandler(filteredPullRequests, authUser)
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
}
