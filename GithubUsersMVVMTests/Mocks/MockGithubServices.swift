//
//  MockGithubServices.swift
//  GithubUsersMVVMTests
//
//  Created by Greener Chen on 2020/4/9.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import Alamofire
@testable import GithubUsersMVVM

class MockGithubSearchService: GithubSearchService {
    
    var stubSearchedUsersItems: [GithubUserItem]?
    var stubSearchedUsersPaginations: Paginations?
    var stubSearchedError: AFError?
    override func searchUsers(query text: String, page: Int = 1, numPerPage: Int = GITHUB_DEFAULT_NUMBER_PER_PAGE, completion: @escaping SearchUsersResponse) {
        completion(stubSearchedUsersItems, stubSearchedUsersPaginations, stubSearchedError)
    }
}

class MockGithubUsersService: GithubUsersService {
    
    var stubSearchedSingleUser: GithubSingleUser?
    var stubSearchedError: AFError?
    override func singleUser(username: String, completion: @escaping SearchSingleUserResponse) {
        completion(stubSearchedSingleUser!, stubSearchedError)
    }
}
