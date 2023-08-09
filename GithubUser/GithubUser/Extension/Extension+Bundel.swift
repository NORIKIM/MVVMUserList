//
//  Extension+Bundel.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import Foundation

extension Bundle {
    var userInfoPlistFile: String {
        guard let path = self.path(forResource: "UserInfo", ofType: "plist") else { return "" }
        return path
    }
    var userInfoResource: NSDictionary {
        guard let resource = NSDictionary(contentsOfFile: userInfoPlistFile) else { return [:] }
        return resource
    }
    var clientID: String {
        guard let value = userInfoResource["CLIENT_ID"] as? String else {
            fatalError(ErrorMessage.readClientIdFail)
        }
        return value
    }
    var clientSecret: String {
        guard let value = userInfoResource["CLIENT_SECRET"] as? String else {
            fatalError(ErrorMessage.readClientSecretFail)
        }
        return value
    }
}
