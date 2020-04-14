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
    var user: SingleUser?
    let (displaySignal, displayObserver) = Signal<SingleUser,Never>.pipe()
    
    var usersService: GithubUsersService? = GithubServiceContainer.shared.resolve(GithubUsersService.self)
    
    func download(username: String, dispatchGroup: DispatchGroup? = nil, sequentialDisplay: Bool = true) {
        dispatchGroup?.enter()

        usersService?.singleUser(username: username, completion: { [weak self] (singleUser, error) in
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
}

struct SearchUserCellModelBuilder {
    
    private let model: SearchUserCellModel
    
    init() {
        model = SearchUserCellModel()
    }
    
    func buildEmptyDescription(_ emptyDescription: String) -> Self {
        model.emptyDescription = emptyDescription
        return self
    }
    
    func buildErrorDescription(_ errorDescription: String) -> Self {
        model.errorDescription = errorDescription
        return self
    }
    
    func buildUser(_ username: String, dispatchGroup: DispatchGroup? = nil, sequentialDisplay: Bool = true) -> Self {
        model.download(username: username, dispatchGroup: dispatchGroup, sequentialDisplay: sequentialDisplay)
        return self
    }
    
    func getModel() -> SearchUserCellModel {
        return model
    }
}
