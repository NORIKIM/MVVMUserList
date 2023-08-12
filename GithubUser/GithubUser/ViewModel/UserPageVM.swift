//
//  UserPageVM.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/12.
//

import UIKit

class UserPageVM {
    // page
    let perPage = 30
    var currentPage = -1
    var totalPage = 1
    var currentKeyword = ""
    // page content
    var reloadTableView: (() -> Void)?
    var userCellVMs = [UserCellVM]() {
        didSet {
            reloadTableView?()
        }
    }
    
    func freshPage(from keyword: String?) {
        if keyword != nil && keyword != currentKeyword {
            currentPage = -1
            totalPage = 1
            currentKeyword = keyword!
            userCellVMs.removeAll()
        }
    }
    
    func settingCurrentPage() {
        if currentPage < totalPage {
            if currentPage == -1 {
                currentPage = 1
            } else {
                currentPage += 1
            }
        }
    }
    
    func isLastPage() -> Bool {
        return currentPage == totalPage ? true : false
    }
    
    func isNeedRequest(with keyword: String?) -> Bool {
        /*
           api 실행 조건
         1. 최초
         2. loadmore
         3. 다른 검색어
         4. 마지막 페이지가 아닐 때
         */
        return (currentKeyword == "Q" || keyword == nil || keyword != currentKeyword) && isLastPage() == false
    }
    
    func fetchUserList(userList:[User]) {
        var userCellVM = [UserCellVM]()
        for user in userList {
            userCellVM.append(setCellModel(user: user))
        }
        userCellVMs.append(contentsOf: userCellVM)
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
    
    func requestAvatarImage(url: String, completion: @escaping (UIImage?) -> ()) {
        Service.shared.requestDownloadImage(from: url) { result in
            completion(result)
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> UserCellVM {
        return userCellVMs[indexPath.row]
    }
}
