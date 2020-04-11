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
    var node_id: String
    var avatar_url: String
    var gravatar_id: String
    var url: String
    var html_url: String
    var followers_url: String
    var subscriptions_url: String
    var organizations_url: String
    var repos_url: String
    var received_events_url: String
    var type: String
    var score: Float
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
                
                if let linkHeader = response.response?.headers["Link"] {
                    let paginations: Paginations = Paginations(linkHeader: linkHeader)
                    let resObj = try! JSONDecoder().decode(GithubUsersSearchResponse.self, from: response.data!)
                    completion(resObj.items, paginations, nil)
                }
        }
        
    }
}


