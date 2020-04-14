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
        case none
        case loading
        case loadingMore
        case emptyResults
        case error
        case loaded
    }
    
    var searchState: MutableProperty<SearchState>
    var users: [String]?
    var paginations: Paginations?
    var emptyDescription: String?
    var errorDescription: String?
    
    // dependencies
    var searchService: GithubSearchService? = GithubServiceContainer.shared.resolve(GithubSearchService.self)
    
    let dispatchGroup = DispatchGroup()
    
    init(searchState: SearchState = SearchState.emptyResults,
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
    
    func update(searchState: SearchState = SearchState.emptyResults,
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
        guard !query.isEmpty else {
            update(searchState: .none, emptyDescription: "Enter a keyword to start searching Github users.")
            return
        }
        
        searchState.value = .loading
        searchService?.searchUsers(query: query, page: 1, completion: { [weak self] users, paginations, error in
            
            guard error == nil else {
                self?.update(searchState: .error, errorDescription: error?.localizedDescription)
                return
            }
            
            if let users = users,
                let paginations = paginations {
                if users.isEmpty {
                    self?.update(searchState: .emptyResults, emptyDescription: "0 users found. Try to search another keyword.")
                } else {
                    let usernames = users.map { $0.login }
                    self?.update(searchState: .loaded, users: usernames, paginations: paginations)
                }
            }
        })
    }
    
    func loadMoreUsers(query: String, page: Int) {
        guard !query.isEmpty else {
            update(searchState: .none, emptyDescription: "Enter a keyword to start searching Github users.")
            return
        }
        
        searchState.value = .loadingMore
        searchService?.searchUsers(query: query, page: page, completion: { [weak self] users, paginations, error in
            
            guard error == nil else {
                self?.update(searchState: .error, errorDescription: error?.localizedDescription)
                return
            }
            
            if let users = users,
                let paginations = paginations,
                var currentUsers = self?.users
            {
                currentUsers += users.map { $0.login }
                self?.update(searchState: .loaded, users: currentUsers, paginations: paginations)
            }
        })
    }
    
    func cellModel(at indexPath: IndexPath) -> SearchUserCellModel {
        let user: String? = (users != nil && indexPath.item < users!.count) ? users![indexPath.item] : nil
        return SearchUserCellModelFactory.create(type: cellTypeByState(), emptyDescription: emptyDescription, errorDescription: errorDescription, user: user, dispatchGroup: dispatchGroup, sequentialDisplay: false)
    }
    
    func cellTypeByState() -> SearchUserCellId {
        switch searchState.value {
        case .none, .emptyResults, .loading:
            return SearchUserCellId.empty
        case .error:
            return SearchUserCellId.error
        case .loaded, .loadingMore:
            return SearchUserCellId.ideal
        }
    }
}

