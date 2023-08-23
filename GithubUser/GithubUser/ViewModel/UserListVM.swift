//
//  UserListVM.swift
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
    private var userPage = UserPageVM()
    typealias callBack = (_ isSuccess:Bool) -> ()
    
    init() {}
    
    func requestUser(keyword: String, completion: @escaping callBack) {
        Service.shared.requestUser(keyword: keyword, page: 1) { [weak self] result in
            guard let userPage = self?.userPage else { return }
            
            if let searchResult = result {
                let totalCount = searchResult.total_count
                let page = totalCount / userPage.perPage
                let userList = searchResult.items
                
                userPage.totalPage = page == 0 ? 1 : page
                userPage.currentKeyword = keyword
                userPage.fetchUserList(userList: userList)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func requestReloadUser(completion: @escaping callBack) {
        Service.shared.requestUser(keyword: userPage.currentKeyword, page: userPage.currentPage + 1) { [weak self] result in
            guard let userPage = self?.userPage else { return }
            
            if let searchResult = result {
                let userList = searchResult.items
                userPage.fetchUserList(userList: userList)
                userPage.currentPage += 1
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    func getUsers() -> [UserCellVM] {
        return userPage.userCellVMs
    }
    
    func getUser(at indexPath: IndexPath) -> UserCellVM {
        return userPage.getCellViewModel(at: indexPath)
    }
}
