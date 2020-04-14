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
        sut = SearchUserCellModelBuilder().buildEmptyDescription(stubEmptyDescription).getModel()
        XCTAssert(sut.emptyDescription == stubEmptyDescription, "Incorrect empty description \(sut.emptyDescription ?? ""). Expected \(stubEmptyDescription).")
    }

    func testErrorCellModel() {
        let stubErrorDescription = "This is error"
        sut = SearchUserCellModelBuilder().buildErrorDescription(stubErrorDescription).getModel()
        XCTAssert(sut.errorDescription == stubErrorDescription, "Incorrect error description \(sut.errorDescription ?? ""). Expected \(stubErrorDescription).")
    }

    func testIdealCellModel() {
        let stubCellModeUser = StubGithubUserFactory()
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
        
        sut = SearchUserCellModelBuilder().buildUser(stubUser.login).getModel()
        let testUser = sut.user!
        XCTAssert(testUser == stubCellModeUser, "Incorrect user \(testUser.username ?? "n/a"). Expected \(stubCellModeUser.username ?? "n/a").")
    }
}
