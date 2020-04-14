//
//  StubGithubUserFactory.swift
//  GithubUsersMVVMTests
//
//  Created by Greener Chen on 2020/4/11.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
@testable import GithubUsersMVVM

struct StubGithubUserFactory {
    func createSearchUserCellModelSingleUser(username: String,
                                             avatarUrl: String,
                                             screenName: String,
                                             location: String?,
                                             publicRepos: Int,
                                             followers: Int,
                                             following: Int) -> SearchUserCellModel.SingleUser {
        return SearchUserCellModel.SingleUser(username: username,
                                              avatarUrl: avatarUrl,
                                              screenName: screenName,
                                              location: location,
                                              publicRepos: publicRepos,
                                              followers: followers,
                                              following: following)
    }
    
    func createGithubSingleUser(login: String,
        id: Int,
        nodeId: String = "",
        avatarUrl: String = "",
        gravatarId: String = "",
        url: String = "",
        htmlUrl: String = "",
        followersUrl: String = "",
        followingUrl: String = "",
        gistsUrl: String = "",
        starredUrl: String = "",
        subscriptionsUrl: String = "",
        organizationsUrl: String = "",
        reposUrl: String = "",
        eventsUrl: String = "",
        receivedEventsUrl: String = "",
        type: String = "",
        siteAdmin: Bool = false,
        name: String = "",
        company: String? = nil,
        blog: String? = nil,
        location: String? = nil,
        email: String? = nil,
        hireable: Bool? = nil,
        bio: String? = nil,
        publicRepos: Int = 0,
        publicGists: Int = 0,
        followers: Int = 0,
        following: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()) -> GithubSingleUser {
        return GithubSingleUser(login: login, id: id, nodeId: nodeId, avatarUrl: avatarUrl, gravatarId: gravatarId, url: url, htmlUrl: htmlUrl, followersUrl: followersUrl, followingUrl: followingUrl, gistsUrl: gistsUrl, starredUrl: starredUrl, subscriptionsUrl: subscriptionsUrl, organizationsUrl: organizationsUrl, reposUrl: reposUrl, eventsUrl: eventsUrl, receivedEventsUrl: receivedEventsUrl, type: type, siteAdmin: siteAdmin, name: name, company: company, blog: blog, location: location, email: email, hireable: hireable, bio: bio, publicRepos: publicRepos, publicGists: publicGists, followers: followers, following: following, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    func createGithubUserItem(login: String,
        id: Int,
        nodeId: String = "",
        avatarUrl: String = "",
        gravatarId: String = "",
        url: String = "",
        htmlUrl: String = "",
        followersUrl: String = "",
        subscriptionsUrl: String = "",
        organizationsUrl: String = "",
        reposUrl: String = "",
        receivedEventsUrl: String = "",
        _type: String = "",
        score: Float = 10.0) -> GithubUserItem {
        return GithubUserItem(login: login,
                              id: id,
                              nodeId: nodeId,
                              avatarUrl: avatarUrl,
                              gravatarId: gravatarId,
                              url: url,
                              htmlUrl: htmlUrl,
                              followersUrl: followersUrl,
                              subscriptionsUrl: subscriptionsUrl,
                              organizationsUrl: organizationsUrl,
                              reposUrl: reposUrl,
                              receivedEventsUrl: receivedEventsUrl,
                              _type: _type,
                              score: score)
    }
}
