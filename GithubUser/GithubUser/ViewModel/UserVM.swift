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
    var isLastPage = false
    let perPage = 30
    var currentPage = -1
    var totalPage = 1
    var currentKeyword = ""
    var reloadTableView: (() -> Void)?
    var userCellVMs = [UserCellVM]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init() {}
    
    
    func requestUser(keyword: String?) {
        
        /*
           api 실행 조건
         1. 최초
         2. loadmore
         3. 다른 검색어
         4. 마지막 페이지가 아닐 때
         */
        let isNeedRequest = (currentKeyword == "Q" || keyword == nil || keyword != currentKeyword) && isLastPage == false
        
        if keyword != nil && keyword != currentKeyword {
            isLastPage = false
            currentPage = -1
            totalPage = 1
            currentKeyword = keyword!
            userCellVMs.removeAll()
        }
        
        if currentPage < totalPage {
            if currentPage == -1 {
                currentPage = 1
            } else {
                currentPage += 1
            }
        }
        
        if isNeedRequest {
            Service.shared.requestUser(keyword: currentKeyword, page: currentPage) { result in
                if self.totalPage == 1 {
                    if let totalPage = result?.total_count {
                        let page = totalPage / self.perPage
                        self.totalPage = page == 0 ? 1 : page
                    }
                }
                
                self.isLastPage = self.currentPage == self.totalPage ? true : false
                
                if let userList = result?.items {
                    self.fetchUserList(userList: userList)
                }
            }
        }
    }
    
    func fetchUserList(userList:[User]) {
        var userCellVM = [UserCellVM]()
        for user in userList {
            userCellVM.append(setCellModel(user: user))
        }
        userCellVMs.append(contentsOf: userCellVM)
    }
    
    func requestAvatarImage(url: String, completion: @escaping (UIImage?) -> ()) {
        Service.shared.requestDownloadImage(from: url) { result in
            completion(result)
        }
    }
    
    func setCellModel(user: User) -> UserCellVM {
        let avatarURL = user.avatar_url
        var avatarImg: UIImage?
        requestAvatarImage(url: avatarURL) { result in
            avatarImg = result
        }
        let login = user.login
        let url = user.html_url
        
        return UserCellVM(avatarImg: avatarImg, login: login, url: url)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> UserCellVM {
        return userCellVMs[indexPath.row]
    }
}
