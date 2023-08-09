//
//  SceneDelegate.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // navigationController 설정
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: scene)
            self.window = window
            
            let navi = UINavigationController()
            navi.isNavigationBarHidden = true
            self.window?.rootViewController = navi
            
            let coordinator = AppCoordinator(navi: navi)
            coordinator.start()
            
            self.window?.makeKeyAndVisible()
        }
    }
    
    // github auth 로그인 후 호출
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
            // accesstoken 요청
            Service.shared.requestAccessToken(with: code)
        }
    }

}

