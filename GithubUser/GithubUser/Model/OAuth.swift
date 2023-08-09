//
//  OAuth.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/07.
//

import Foundation

struct OAuth: Codable {
    let access_token: String
    let scope: String
    let token_type: String
}
