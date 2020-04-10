//
//  GithubService.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import Foundation
import Alamofire

let GITHUB_ROOT_ENDPOINT: String = "https://api.github.com"
let GITHUB_OAUTH_TOKEN: String = "" // Put your Github oAuth token here for rates limit of Github API requests
let GITHUB_DEFAULT_HEADERS: HTTPHeaders = ["Accept": "application/vnd.github.v3+json", "Authorization": "token \(GITHUB_OAUTH_TOKEN)"]
let GITHUB_DEFAULT_NUMBER_PER_PAGE: Int = 30

struct Paginations {
    var next: Int?
    var last: Int?
    var first: Int?
    var prev: Int?
    
    init(linkHeader: String) {
        let splits = linkHeader.split(separator: ",")
        let relPattern = "rel=\"(\\w+)\""
        let relRegex = try! NSRegularExpression(pattern: relPattern, options: [])
        let pagePattern = "page=(\\d+)"
        let pageRegex = try! NSRegularExpression(pattern: pagePattern, options: [])
        for s in splits {
            let split = String(s)
            let range = NSRange(split.startIndex..<split.endIndex, in: split)
            let relMatch = relRegex.firstMatch(in: split, options: [], range: range)
            let rel = (split as NSString).substring(with: relMatch!.range(at: 1))
            let pageMatch = pageRegex.firstMatch(in: split, options: [], range: range)
            let page = (split as NSString).substring(with: pageMatch!.range(at: 1))
            switch rel {
            case "next":
                next = Int(page)
            case "last":
                last = Int(page)
            case "first":
                first = Int(page)
            case "prev":
                prev = Int(page)
            default:
                break
            }
        }
    }
}

protocol GithubServiceProtocol {
    func sendGetRequest(_ url: String, parameters: Parameters, headers: HTTPHeaders) -> DataRequest
}

class GithubService {
    
    let rootEndpoint: String = GITHUB_ROOT_ENDPOINT
    let defaultHeaders: HTTPHeaders = GITHUB_DEFAULT_HEADERS
    var url: String
    
    init(path: String) {
        url = rootEndpoint + path
    }
    
}

extension GithubService: GithubServiceProtocol {
    
    func sendGetRequest(_ url: String, parameters: Parameters, headers: HTTPHeaders) -> DataRequest {
        return AF.request(url, parameters: parameters, headers: headers)
    }
}
