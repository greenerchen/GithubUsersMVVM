//
//  Swinject+Helpers.swift
//  GithubUsersMVVMTests
//
//  Created by Greener Chen on 2020/4/9.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Swinject

extension ObjectScope {
    static let discardedAfterTest = ObjectScope(storageFactory: PermanentStorage.init, description: "discardedAfterTest")
}
