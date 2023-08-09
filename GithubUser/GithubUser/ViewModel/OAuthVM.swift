//
//  OAuthVM.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/07.
//

import Foundation
import Moya

struct OAuthVM {
    static let shared = OAuthVM()
    private init() {}
    
    // github 로그인 페이지 연결
    func connnectGithub() {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        let clientID = Bundle.main.clientID
        let scope = "repo gist user"
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        let urlString = components.url?.absoluteString
        
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }    
}
