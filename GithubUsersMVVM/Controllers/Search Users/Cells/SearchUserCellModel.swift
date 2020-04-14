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
    
    var emptyDescription: String?
    var errorDescription: String?
    private(set) var user: SingleUser?
    let (displaySignal, displayObserver) = Signal<SingleUser,Never>.pipe()
    
    var usersService: GithubUsersService? = GithubServiceContainer.shared.resolve(GithubUsersService.self)
    
    init(user: String? = nil, emptyDescription: String? = nil, errorDescription: String? = nil, dispatchGroup: DispatchGroup? = nil, sequentialDisplay: Bool = true) {
        if let user = user {
            dispatchGroup?.enter()
            
            usersService?.singleUser(username: user, completion: { [weak self] (singleUser, error) in
                guard error == nil else {
                    self?.user = SingleUser(username: singleUser.login, avatarUrl: nil, screenName: nil, location: nil, publicRepos: 0, followers: 0, following: 0)
                    self?.displayObserver.send(value: (self?.user)!)
                    return
                }
                
                self?.user = SingleUser(username: singleUser.login,
                                                  avatarUrl: singleUser.avatarUrl,
                                                  screenName: singleUser.name,
                                                  location: singleUser.location,
                                                  publicRepos: singleUser.publicRepos,
                                                  followers: singleUser.followers,
                                                  following: singleUser.following)
                if sequentialDisplay {
                    self?.displayObserver.send(value: (self?.user)!)
                }
            
                dispatchGroup?.leave()
            })
                
            dispatchGroup?.notify(queue: DispatchQueue.global()) { [weak self] in
                if !sequentialDisplay {
                    self?.displayObserver.send(value: (self?.user)!)
                }
            }
            
            
        }
        
        self.emptyDescription = emptyDescription
        self.errorDescription = errorDescription
    }
}

struct SearchUserCellModelFactory {
    
    static func create(type: SearchUserCellId, emptyDescription: String? = nil, errorDescription: String? = nil, user: String?, dispatchGroup: DispatchGroup? = nil, sequentialDisplay: Bool = true) -> SearchUserCellModel {
        switch type {
        case .empty:
            return SearchUserCellModel(emptyDescription: emptyDescription!)
        case .error:
            return SearchUserCellModel(errorDescription: errorDescription!)
        case .ideal:
            return SearchUserCellModel(user: user, dispatchGroup: dispatchGroup, sequentialDisplay: sequentialDisplay)
        }
    }
    
}
