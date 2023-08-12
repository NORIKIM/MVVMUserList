//
//  UserVM.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import Foundation
import UIKit

/* 참고:
 MVVM 패턴 https://johncodeos.com/how-to-implement-mvvm-pattern-with-swift-in-ios/
 페이징 https://swieeft.github.io/2020/07/20/PagingTableView.html
 class vs. struct https://showcove.medium.com/swift-struct-vs-class-1-68cf9cbf87ca
*/


class UserListVM {
    var userPage = UserPageVM()

    init() {}
    
    func requestUser(keyword: String?) {
        userPage.settingUserPage(by: keyword)
        
        let isNeedRequest = userPage.isNeedRequest(with: keyword)
        
        if isNeedRequest {
            Service.shared.requestUser(keyword: userPage.currentKeyword, page: userPage.currentPage) { [weak self] result in
                guard let userPage = self?.userPage else { return }
                
                if userPage.totalPage == 1 {
                    if let totalPage = result?.total_count {
                        let page = totalPage / userPage.perPage
                        userPage.totalPage = page == 0 ? 1 : page
                    }
                }
                
                if let userList = result?.items {
                    userPage.fetchUserList(userList: userList)
                }
            }
        }
    }
}
