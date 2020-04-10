//
//  SearchUserCellModel.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import ReactiveSwift

class SearchUserCellModel {
    
    struct SingleUser: Equatable {
        var username: String?
        var avatarUrl: String?
        var screenName: String?
        var location: String?
        var publicRepos: Int
        var followers: Int
        var following: Int
        
        static func == (lhs: SingleUser, rhs: SingleUser) -> Bool {
            return lhs.username == rhs.username &&
                lhs.avatarUrl == rhs.avatarUrl &&
                lhs.screenName == rhs.screenName &&
                lhs.location == rhs.location &&
                lhs.publicRepos == rhs.publicRepos &&
                lhs.followers == rhs.followers &&
                lhs.following == rhs.following
        }
    }
    
    var emptyDescription: String? = nil
    var errorDescription: String? = nil
    var user: MutableProperty<SingleUser?> = MutableProperty(nil)
    
    var usersService: GithubUsersService? = GithubServiceContainer.shared.resolve(GithubUsersService.self)
    
    init(user: String? = nil, emptyDescription: String? = nil, errorDescription: String? = nil) {
        if let user = user {
            usersService?.singleUser(username: user, completion: { [weak self] (singleUser, error) in
                guard error == nil else {
                    self?.user = MutableProperty(SingleUser(username: singleUser.login, avatarUrl: nil, screenName: nil, location: nil, publicRepos: 0, followers: 0, following: 0))
                    return
                }
                
                self?.user.value = SingleUser(username: singleUser.login,
                                              avatarUrl: singleUser.avatarUrl,
                                              screenName: singleUser.name,
                                              location: singleUser.location,
                                              publicRepos: singleUser.publicRepos,
                                              followers: singleUser.followers,
                                              following: singleUser.following)
            })
        }
        
        self.emptyDescription = emptyDescription
        self.errorDescription = errorDescription
    }
}

struct SearchUserCellModelFactory {
    
    static func create(type: SearchUserCellId, emptyDescription: String? = nil, errorDescription: String? = nil, user: String?) -> SearchUserCellModel {
        switch type {
        case .Empty:
            return SearchUserCellModel(emptyDescription: emptyDescription!)
        case .Error:
            return SearchUserCellModel(errorDescription: errorDescription!)
        case .Ideal:
            return SearchUserCellModel(user: user)
        }
    }
    
}
