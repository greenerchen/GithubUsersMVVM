//
//  GithubUsersService.swift
//  GithubUsersMVVM
//
//  Created by Greener Chen on 2020/4/9.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import Alamofire

struct GithubSingleUser: Codable {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: String
    var gravatarId: String
    var url: String
    var htmlUrl: String
    var followersUrl: String
    var followingUrl: String
    var gistsUrl: String
    var starredUrl: String
    var subscriptionsUrl: String
    var organizationsUrl: String
    var reposUrl: String
    var eventsUrl: String
    var receivedEventsUrl: String
    var type: String
    var siteAdmin: Bool
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: Bool?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias SearchSingleUserResponse = (GithubSingleUser, AFError?) -> Void

protocol GithubUsersServiceProtocol {
    func singleUser(username: String, completion: @escaping SearchSingleUserResponse)
}

class GithubUsersService: GithubService, GithubUsersServiceProtocol {
    
    init() {
        super.init(path: "/users/")
    }
    
    func singleUser(username: String, completion: @escaping SearchSingleUserResponse) {
        self.sendGetRequest(url+username, parameters: [:], headers: self.defaultHeaders)
            .response { (response) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let userObj = try! decoder.decode(GithubSingleUser.self, from: response.data!)
                completion(userObj, nil)
        }
    }
    
}
