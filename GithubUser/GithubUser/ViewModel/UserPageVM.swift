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
    var currentPage = 1
    var totalPage = 1
    var currentKeyword = ""
    var isLastPageFlag = false
    // page content
    var userCellVMs = [UserCellVM]()
    
    func isLastPage() -> Bool {
        isLastPageFlag = currentPage == totalPage ? true : false
        return isLastPageFlag
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
