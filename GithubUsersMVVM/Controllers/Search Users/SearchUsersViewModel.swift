//
//  SearchUsersViewModel.swift
//  GithubUsersMVVM
//
//  Created by Greener Chen on 2020/4/10.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SearchUsersViewModelProtocol {
    func loadUsers(query: String)
    func loadMoreUsers(query: String, page: Int)
    func cellModel(at indexPath: IndexPath) -> SearchUserCellModel
    func cellTypeByState() -> SearchUserCellId
}

class SearchUsersViewModelFactory {
    class func create(searchState: SearchUsersViewModel.SearchState,
                users: [String]? = nil,
                paginations: Paginations? = nil,
                emptyDescription: String? = "Enter a keyword to start searching Github users.",
                errorDescription: String? = nil) -> SearchUsersViewModel {
        return SearchUsersViewModel(searchState: searchState,
                                    users: users,
                                    paginations: paginations,
                                    emptyDescription: emptyDescription,
                                    errorDescription: errorDescription)
    }
}

class SearchUsersViewModel {
    
    enum SearchState {
        case None
        case Loading
        case LoadingMore
        case EmptyResults
        case Error
        case Loaded
    }
    
    var searchState: MutableProperty<SearchState>
    var users: [String]?
    var paginations: Paginations?
    var emptyDescription: String?
    var errorDescription: String?
    
    // dependencies
    var searchService: GithubSearchService? = GithubServiceContainer.shared.resolve(GithubSearchService.self)
    
    init(searchState: SearchState = SearchState.EmptyResults,
         users: [String]? = nil,
         paginations: Paginations? = nil,
         emptyDescription: String? = "Enter a keyword to start searching Github users.",
         errorDescription: String? = nil)
    {
        self.searchState = MutableProperty(searchState)
        self.users = users
        self.paginations = paginations
        self.emptyDescription = emptyDescription
        self.errorDescription = errorDescription
    }
    
    func update(searchState: SearchState = SearchState.EmptyResults,
         users: [String]? = nil,
         paginations: Paginations? = nil,
         emptyDescription: String? = nil,
         errorDescription: String? = nil)
    {
        self.searchState.value = searchState
        self.users = users
        self.paginations = paginations
        self.emptyDescription = emptyDescription
        self.errorDescription = errorDescription
    }
}

extension SearchUsersViewModel: SearchUsersViewModelProtocol {
    
    func loadUsers(query: String) {
        guard query.count > 0 else {
            update(searchState: .None, emptyDescription: "Enter a keyword to start searching Github users.")
            return
        }
        
        searchState.value = .Loading
        searchService?.searchUsers(query: query, page: 1, completion: { [weak self] users, paginations, error in
            
            guard error == nil else {
                self?.update(searchState: .Error, errorDescription: error?.localizedDescription)
                return
            }
            
            if let users = users,
                let paginations = paginations {
                if users.count == 0 {
                    self?.update(searchState: .EmptyResults, emptyDescription: "0 users found. Try to search another keyword.")
                } else {
                    let usernames = users.map { $0.login }
                    self?.update(searchState: .Loaded, users: usernames, paginations: paginations)
                }
            }
        })
    }
    
    func loadMoreUsers(query: String, page: Int) {
        guard query.count > 0 else {
            update(searchState: .None, emptyDescription: "Enter a keyword to start searching Github users.")
            return
        }
        
        searchState.value = .LoadingMore
        searchService?.searchUsers(query: query, page: page, completion: { [weak self] users, paginations, error in
            
            guard error == nil else {
                self?.update(searchState: .Error, errorDescription: error?.localizedDescription)
                return
            }
            
            if let users = users,
                let paginations = paginations,
                var currentUsers = self?.users {
                if users.count > 0 {
                    currentUsers += users.map { $0.login }
                    self?.update(searchState: .Loaded, users: currentUsers, paginations: paginations)
                }
            }
        })
    }
    
    func cellModel(at indexPath: IndexPath) -> SearchUserCellModel {
        let user: String? = (users != nil && indexPath.item < users!.count) ? users![indexPath.item] : nil
        return SearchUserCellModelFactory.create(type: cellTypeByState(), emptyDescription: emptyDescription, errorDescription: errorDescription, user: user)
    }
    
    func cellTypeByState() -> SearchUserCellId {
        switch searchState.value {
        case .None, .EmptyResults, .Loading:
            return SearchUserCellId.Empty
        case .Error:
            return SearchUserCellId.Error
        case .Loaded, .LoadingMore:
            return SearchUserCellId.Ideal
        }
    }
}

