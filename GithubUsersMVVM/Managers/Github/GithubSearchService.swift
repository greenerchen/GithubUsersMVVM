//
//  GithubSearchService.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import Alamofire

struct GithubUsersSearchResponse: Codable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [GithubUserItem]
}

struct GithubUserItem: Codable {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: String
    var gravatarId: String
    var url: String
    var htmlUrl: String
    var followersUrl: String
    var subscriptionsUrl: String
    var organizationsUrl: String
    var reposUrl: String
    var receivedEventsUrl: String
    var _type: String
    var score: Float
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case receivedEventsUrl = "received_events_url"
        case _type = "type"
        case score
    }
}

typealias SearchUsersResponse = ([GithubUserItem]?, Paginations?, Error?) -> Void

protocol GithubSearchServiceProtocol {
    func searchUsers(query text: String, page: Int, numPerPage: Int, completion: @escaping SearchUsersResponse)
}

class GithubSearchService: GithubService, GithubSearchServiceProtocol {
    
    init() {
        super.init(path: "/search/users")
    }
    
    func searchUsers(query text: String, page: Int = 1, numPerPage: Int = GITHUB_DEFAULT_NUMBER_PER_PAGE, completion: @escaping SearchUsersResponse) {
        let parameters: Parameters = ["q": text, "page": page, "per_page": numPerPage]
        self.sendGetRequest(url, parameters: parameters, headers: self.defaultHeaders)
            .response { (response) in
                guard response.value != nil else {
                    completion(nil, nil, response.error!)
                    return
                }
                
                guard let code = response.response?.statusCode, code == 200 else {
                    completion(nil, nil, response.error!)
                    return
                }
                
                if let linkHeader = response.response?.headers["Link"] {
                    let paginations: Paginations = Paginations(linkHeader: linkHeader)
                    let resObj = try! JSONDecoder().decode(GithubUsersSearchResponse.self, from: response.data!)
                    completion(resObj.items, paginations, nil)
                }
        }
        
    }
}


