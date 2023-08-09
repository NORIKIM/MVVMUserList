//
//  Coordinator.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import UIKit

// 참고: https://zeddios.medium.com/coordinator-pattern-bf4a1bc46930

protocol Coordinator {
    var coordinators: [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    private var navi: UINavigationController!
    var coordinators: [Coordinator] = []
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let signInToken = KeyChain.shared.read()
        
        if signInToken != nil {
            showMainViewController()
        } else {
            showIntroViewController()
        }
    }
    
    private func showIntroViewController() {
        let introCoordinator = IntroCoordinator(navi: navi)
        introCoordinator.start()
        coordinators.append(introCoordinator)
        
        KeyChain.shared.delegate = self
    }
    
    private func showMainViewController() {
        let mainCoordinator = MainCoordinator(navi: navi)
        mainCoordinator.start()
        coordinators.append(mainCoordinator)
    }
}


extension AppCoordinator: KeyChainDelegate {
    func didSignIn() {
        coordinators = coordinators.filter{ ($0 as? IntroCoordinator) == nil }
        showMainViewController()
    }
}
