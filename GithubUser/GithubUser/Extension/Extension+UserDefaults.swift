//
//  Extension+UserDefaults.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/08.
//

import Foundation

// 참고: https://ios-development.tistory.com/262

extension UserDefaults {
    public static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = UserDefaultsKey.hasBeenLaunchedBeforeFlag
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
