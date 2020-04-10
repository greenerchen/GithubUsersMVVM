//
//  GithubServicesContainer.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/12.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import Swinject
    
class GithubServiceContainer {
    
    static let shared: Container = {
        let c = Container()
        c.register(GithubSearchService.self) { _ in GithubSearchService() }
        c.register(GithubUsersService.self) { _ in GithubUsersService() }
        return c
    }()
}


