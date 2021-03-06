//
//  SearchUsersViewModelTests.swift
//  GithubUsersMVVMTests
//
//  Created by Greener Chen on 2020/4/8.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import XCTest
import Swinject
@testable import GithubUsersMVVM

class SearchUsersViewModelTests: XCTestCase {

    var sut: SearchUsersViewModel!
    var mockSearchService: MockGithubSearchService!
    var mockUsersService: MockGithubUsersService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchStateNone() {
        let stubEmptyDesc = "This is none"
        sut = SearchUsersViewModel(searchState: .none, emptyDescription: stubEmptyDesc)
        XCTAssert(sut.emptyDescription == stubEmptyDesc, "Incorrect empty description \(sut.emptyDescription ?? ""). Expected \(stubEmptyDesc).")
    }

    func testSearchStateErrorResult() {
        let stubErrorDesc = "This is error"
        sut = SearchUsersViewModel(searchState: .error, errorDescription: stubErrorDesc)
        XCTAssert(sut.errorDescription == stubErrorDesc, "Incorrect error description \(sut.errorDescription ?? ""). Expected \(stubErrorDesc).")
    }
    
    func testSearchStateEmptyResult() {
        let stubEmptyDesc = "0 users found. Try to search another keyword."
            
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedUsersItems = []
        mockSearchService.stubSearchedUsersPaginations = Paginations(linkHeader: "<https://api.github.com/user/repos?page=50&per_page=100>; rel=\"last\"")
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUsersViewModel(searchState: .emptyResults, emptyDescription: stubEmptyDesc)
        sut.loadUsers(query: "cat")
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.emptyResults, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.emptyResults)")
        XCTAssert(sut.emptyDescription == stubEmptyDesc, "Incorrect empty description \(sut.emptyDescription ?? ""). Expected \(stubEmptyDesc).")
    }

    func testLoadUsers() {
        let stubEmptyDesc = "This is none"
        let stubUser: GithubUserItem = GithubUserItem(login: "octocat", id: 1, nodeId: "", avatarUrl: "https://github.com/images/error/octocat_happy.gif", gravatarId: "", url: "", htmlUrl: "", followersUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "", receivedEventsUrl: "", _type: "", score: 10)
            
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedUsersItems = [stubUser]
        mockSearchService.stubSearchedUsersPaginations = Paginations(linkHeader: "<https://api.github.com/user/repos?page=3&per_page=100>; rel=\"next\", <https://api.github.com/user/repos?page=50&per_page=100>; rel=\"last\"")
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUsersViewModel(searchState: .none, emptyDescription: stubEmptyDesc)
        sut.loadUsers(query: "cat")
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.loaded, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.loaded)")
        XCTAssert(sut.users?.count == 1, "Incorrect loaded user count \(sut.users?.count ?? 0). Expected 1.")
        XCTAssert(sut.users?.first == stubUser.login, "Incorrect loaded user \(sut.users?.first ?? "n/a"). Expected \(stubUser.login)")
    }
    
    func testLoadUsersWithErrors() {
        let stubEmptyDesc = "This is none"
            
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedError = NSError(domain: "NSURLErrorDomain", code: NSURLErrorTimedOut, userInfo: nil)
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUsersViewModel(searchState: .none, emptyDescription: stubEmptyDesc)
        sut.loadUsers(query: "cat")
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.error, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.error)")
        XCTAssertNil(sut.users, "Incorrect loaded users. Expected nil.")
    }
    
    func testLoadNoMoreUsers() {
        let stubUser1: GithubUserItem = StubGithubUserFactory().createGithubUserItem(login: "octocat",
                                                                                     id: 1,
                                                                                     avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                                                                     score: 10.0)
        
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedUsersItems = []
        mockSearchService.stubSearchedUsersPaginations = Paginations(linkHeader: "<https://api.github.com/user/repos?page=3&per_page=100>; rel=\"next\", <https://api.github.com/user/repos?page=50&per_page=100>; rel=\"last\"")
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUsersViewModel(searchState: .loaded, users: [stubUser1.login])
        sut.loadMoreUsers(query: "cat", page: 2)
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.loaded, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.loaded)")
        XCTAssertNotNil(sut.users, "Users are nil")
        XCTAssert(sut.users?.count == 1, "Incorrect loaded user count \(sut.users?.count ?? 0). Expected 1.")
        XCTAssert(sut.users?.first == stubUser1.login, "Incorrect loaded user \(sut.users?.first ?? "n/a"). Expected \(stubUser1.login)")
    }
    
    func testLoadMoreUsersOnce() {
        let stubUser1: GithubUserItem = StubGithubUserFactory().createGithubUserItem(login: "octocat",
                                                                                     id: 1,
                                                                                     avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                                                                     score: 10.0)
        let stubUser2: GithubUserItem = StubGithubUserFactory().createGithubUserItem(login: "starcat",
                                                                                     id: 2,
                                                                                     avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                                                                     score: 11.0)
        
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedUsersItems = [stubUser2]
        mockSearchService.stubSearchedUsersPaginations = Paginations(linkHeader: "<https://api.github.com/user/repos?page=3&per_page=100>; rel=\"next\", <https://api.github.com/user/repos?page=50&per_page=100>; rel=\"last\"")
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUsersViewModel(searchState: .loaded, users: [stubUser1.login])
        sut.loadMoreUsers(query: "cat", page: 2)
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.loaded, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.loaded)")
        XCTAssertNotNil(sut.users, "Users are nil")
        XCTAssert(sut.users?.count == 2, "Incorrect loaded user count \(sut.users?.count ?? 0). Expected 1.")
        XCTAssert(sut.users?.first == stubUser1.login, "Incorrect loaded user \(sut.users?.first ?? "n/a"). Expected \(stubUser1.login)")
        XCTAssert(sut.users?.last == stubUser2.login, "Incorrect loaded user \(sut.users?.last ?? "n/a"). Expected \(stubUser2.login)")
    }
    
    func testLoadMoreUsersWithErrors() {
        let stubUser1: GithubUserItem = StubGithubUserFactory().createGithubUserItem(login: "octocat",
                                                                                     id: 1,
                                                                                     avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                                                                     score: 10.0)
        
        mockSearchService = MockGithubSearchService()
        mockSearchService.stubSearchedError = NSError(domain: "NSURLErrorDomain", code: NSURLErrorTimedOut, userInfo: nil)
        
        GithubServiceContainer.shared.register(GithubSearchService.self) { [unowned self] _ in
            self.mockSearchService
        }.inObjectScope(.discardedAfterTest)
        
        
        sut = SearchUsersViewModel(searchState: .loaded, users: [stubUser1.login])
        sut.loadMoreUsers(query: "cat", page: 2)
        XCTAssert(sut.searchState.value == SearchUsersViewModel.SearchState.error, "Incorrect search state \(sut.searchState.value). Expected \(SearchUsersViewModel.SearchState.error)")
        XCTAssertNil(sut.users, "Incorrect loaded users. Expected nil.")
    }
    
    func testGetEmptyCellModel() {
        let stubEmptyDesc1 = "This is none"
        let stubEmptyDesc2 = "0 users found. Try to search another keyword."
        
        sut = SearchUsersViewModel(searchState: .none, emptyDescription: stubEmptyDesc1)
        var model = sut.cellModel(at: IndexPath(item: 0, section: 0))
        XCTAssert(model.emptyDescription! == stubEmptyDesc1, "Incorrect empty description \(model.emptyDescription ?? "n/a"). Expected \(stubEmptyDesc1)")
        
        sut = SearchUsersViewModel(searchState: .emptyResults, emptyDescription: stubEmptyDesc2)
        model = sut.cellModel(at: IndexPath(item: 0, section: 0))
        XCTAssert(model.emptyDescription! == stubEmptyDesc2, "Incorrect empty description \(model.emptyDescription ?? "n/a"). Expected \(stubEmptyDesc2)")
    }
    
    func testGetErrorCellModel() {
        let stubErrorDesc = "This is error"
        sut = SearchUsersViewModel(searchState: .error, errorDescription: stubErrorDesc)
        let model = sut.cellModel(at: IndexPath(item: 0, section: 0))
        XCTAssert(model.errorDescription == stubErrorDesc, "Incorrect error description \(model.errorDescription ?? "n/a"). Expected \(stubErrorDesc).")
    }
    
    func testGetIdealCellModel() {
        let stubCellModelUser = StubGithubUserFactory()
            .createSearchUserCellModelSingleUser(
                username: "octocat",
                avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                screenName: "monalisa octocat",
                location: "San Francisco",
                publicRepos: 2,
                followers: 1,
                following: 0)
        let stubUser: GithubSingleUser = StubGithubUserFactory()
            .createGithubSingleUser(login: "octocat",
                                    id: 1,
                                    avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                    name: "monalisa octocat",
                                    location: "San Francisco",
                                    publicRepos: 2,
                                    followers: 1,
                                    following: 0)
        mockUsersService = MockGithubUsersService()
        mockUsersService.stubSearchedSingleUser = stubUser
        
        GithubServiceContainer.shared.register(GithubUsersService.self) { [unowned self] _ in
            self.mockUsersService
        }.inObjectScope(.discardedAfterTest)
        
        
        sut = SearchUsersViewModel(searchState: .loaded, users: [stubCellModelUser.username!])
        let model = sut.cellModel(at: IndexPath(item: 0, section: 0))
        XCTAssertNotNil(model.user, "User is nil in the cell model")
        XCTAssert(model.user! == stubCellModelUser, "Incorrect user in the cell model")
    }
    
    func testCellTypeForStateNone() {
        sut = SearchUsersViewModel(searchState: .none)
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.empty, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.empty)")
    }
    
    func testCellTypeForStateLoading() {
        sut = SearchUsersViewModel(searchState: .loading)
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.empty, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.empty)")
    }
    
    func testCellTypeForStateError() {
        sut = SearchUsersViewModel(searchState: .error)
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.error, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.error)")
    }
    
    func testCellTypeForStateEmptyResults() {
        sut = SearchUsersViewModel(searchState: .emptyResults)
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.empty, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.empty)")
    }
    
    func testCellTypeForStateLoaded() {
        sut = SearchUsersViewModel(searchState: .loaded, users: ["octocat"])
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.ideal, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.ideal)")
    }
    
    func testCellTypeForStateLoadingMore() {
        sut = SearchUsersViewModel(searchState: .loadingMore)
        let cellType = sut.cellTypeByState()
        XCTAssert(cellType == SearchUserCellId.ideal, "Incorrect cell type \(cellType). Expected \(SearchUserCellId.ideal)")
    }
}
