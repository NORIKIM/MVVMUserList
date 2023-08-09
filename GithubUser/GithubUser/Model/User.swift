//
//  User.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import Foundation

struct UserList: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [User]
}

struct User: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
}
