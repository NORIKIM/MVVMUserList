//
//  AppDelegate.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        removeKeychainAtFirstLaunch()
        
        return true
    }

    private func removeKeychainAtFirstLaunch() {
        guard UserDefaults.isFirstLaunch() else {
            return
        }
        KeyChain.shared.delete()
    }


}

