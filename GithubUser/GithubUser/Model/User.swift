//
//  User.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import Foundation

struct User {
    var user: [User]
    
    var rowCount: Int {
        return user.count
    }
    
    init(user: [User]) {
        self.user = user
    }
}
