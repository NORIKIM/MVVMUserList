//
//  Network.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import Foundation
import Moya

enum Network {
    case accessToken(code: String)
    case user(keyword: String, page: Int)
}

extension Network: TargetType {
    var baseURL: URL {
        switch self {
        case .accessToken:
            let url = "https://github.com"
            let base = URL(string: url)!
            return base
        case .user:
            let url = "https://api.github.com"
            let base = URL(string: url)!
            return base
        }
    }
    
    var path: String {
        switch self {
        case .accessToken:
            return "/login/oauth/access_token"
        case .user:
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .accessToken:
            return .post
        case .user:
            return .get
        }
    }
    
    var task: Moya.Task {
        let clientID = Bundle.main.clientID
        let clientSecret = Bundle.main.clientSecret
        
        switch self {
        case .accessToken(let code):
            let param = ["client_id": clientID,
                         "client_secret": clientSecret,
                         "code": code]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .user(let keyword, let page):
            let param: [String: Any] = ["q": keyword, "page": page]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String:String]? {
        switch self {
        case .accessToken:
            return ["Accept": "application/json"]
        case .user:
            let accessToken = KeyChain.shared.read() ?? ""
            return ["Accept": "application/vnd.github+json",
                    "Authorization": "Bearer \(accessToken)"]
        }
        
    }
}
