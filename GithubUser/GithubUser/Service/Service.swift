//
//  Service.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/08.
//

import Foundation
import Moya

struct Service {
    static let shared = Service()
    let provider = MoyaProvider<Network>()
    
    func requestAccessToken(with code: String) {
        provider.request(.accessToken(code: code)) { result in
            switch result {
            case .success(let response):
                if let result = try? response.map(OAuth.self) {
                    KeyChain.shared.create(token: result.access_token)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    } 
    
    func requestUser(keyword: String, page: Int = 1, completion: @escaping (UserList?) -> ()) {
        provider.request(.user(keyword: keyword, page: page)) { result in
            switch result {
            case .success(let response):
                if let result = try? response.map(UserList.self) {
                    completion(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
                print(ErrorMessage.err)
                completion(nil)
            }
        }
    }
    
    func requestDownloadImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: url)
        if let data = try? Data(contentsOf: url!) {
            if let image = UIImage(data: data) {
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
}
