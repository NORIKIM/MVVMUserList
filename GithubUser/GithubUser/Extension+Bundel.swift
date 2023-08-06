//
//  Extension+Bundel.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import Foundation

extension Bundle {
    var clientID: String {
        guard let plistFile = self.path(forResource: "UserInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: plistFile) else { return "" }
        guard let value = resource["CLIENT_ID"] as? String else {
            fatalError("client ID를 설정해주세요.")
        }
        return value
    }
}
