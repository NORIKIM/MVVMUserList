//
//  IntroCoordinator.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import UIKit

class IntroCoordinator: Coordinator {
    var coordinators: [Coordinator] = []
    private var navi: UINavigationController!
    
    init(navi: UINavigationController!) {
        self.navi = navi
    }
    
    func start() {
        let introVC = IntroViewController()
        self.navi.viewControllers = [introVC]
    }
}
