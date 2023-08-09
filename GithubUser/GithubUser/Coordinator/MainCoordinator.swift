//
//  MainCoordinator.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/07.
//

import UIKit

class MainCoordinator: Coordinator {
    var coordinators: [Coordinator] = []
    private var navi: UINavigationController!
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let mainVC = MainViewController()
        self.navi.viewControllers = [mainVC]
    }
}
