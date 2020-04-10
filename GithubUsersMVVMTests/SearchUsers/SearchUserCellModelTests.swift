//
//  SearchUserCellModelTests.swift
//  GithubUsersMVVMTests
//
//  Created by Greener Chen on 2020/4/9.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import XCTest
import Swinject
@testable import GithubUsersMVVM

class SearchUserCellModelTests: XCTestCase {

    var sut: SearchUserCellModel!
    var mockUsersService: MockGithubUsersService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyCellModel() {
        let stubEmptyDescription = "This is empty"
        sut = SearchUserCellModel(user: nil, emptyDescription: stubEmptyDescription, errorDescription: nil)
        XCTAssert(sut.emptyDescription == stubEmptyDescription, "Incorrect empty description \(sut.emptyDescription ?? ""). Expected \(stubEmptyDescription).")
    }

    func testErrorCellModel() {
        let stubErrorDescription = "This is error"
        sut = SearchUserCellModel(user: nil, emptyDescription: nil, errorDescription: stubErrorDescription)
        XCTAssert(sut.errorDescription == stubErrorDescription, "Incorrect error description \(sut.errorDescription ?? ""). Expected \(stubErrorDescription).")
    }

    func testIdealCellModel() {
        let stubCellModeUser = SearchUserCellModel.SingleUser(username: "octocat",
                                                              avatarUrl: "https://github.com/images/error/octocat_happy.gif",
                                                              screenName: "monalisa octocat",
                                                              bio: "There once was...",
                                                              location: "San Francisco")
        let stubUser: GithubSingleUser = GithubSingleUser(login: "octocat", id: 1, nodeId: "", avatarUrl: "https://github.com/images/error/octocat_happy.gif", gravatarId: "", url: "", htmlUrl: "", followersUrl: "", followingUrl: "", gistsUrl: "", starredUrl: "", subscriptionsUrl: "", organizationsUrl: "", reposUrl: "", eventsUrl: "", receivedEventsUrl: "", type: "", siteAdmin: false, name: "monalisa octocat", company: nil, blog: nil, location: "San Francisco", email: nil, hireable: nil, bio: "There once was...", publicRepos: 1, publicGists: 1, followers: 1, following: 1, createdAt: Date(), updatedAt: Date())
        mockUsersService = MockGithubUsersService()
        mockUsersService.stubSearchedSingleUser = stubUser
        
        GithubServiceContainer.shared.register(GithubUsersService.self) { [unowned self] _ in
            self.mockUsersService
        }.inObjectScope(.discardedAfterTest)
        
        sut = SearchUserCellModel(user: stubUser.login, emptyDescription: nil, errorDescription: nil)
        let testUser = sut.user.value!
        XCTAssert(testUser.username == stubCellModeUser.username, "Incorrect username \(testUser.username ?? "n/a"). Expected \(stubCellModeUser.username ?? "n/a").")
        XCTAssert(testUser.avatarUrl == stubCellModeUser.avatarUrl, "Incorrect avatarUrl \(testUser.avatarUrl ?? "n/a"). Expected \(stubCellModeUser.avatarUrl ?? "n/a").")
        XCTAssert(testUser.screenName == stubCellModeUser.screenName, "Incorrect screenName \(testUser.screenName ?? "n/a"). Expected \(stubCellModeUser.screenName ?? "n/a").")
        XCTAssert(testUser.bio == stubCellModeUser.bio, "Incorrect bio \(testUser.bio ?? "n/a"). Expected \(stubCellModeUser.bio ?? "n/a").")
        XCTAssert(testUser.location == stubCellModeUser.location, "Incorrect location \(testUser.location ?? "n/a"). Expected \(stubCellModeUser.location ?? "n/a").")
    }
}
