//
//  ErrorMessage.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/08.
//

import Foundation

struct ErrorMessage {
    // 네트워크
    static let err = "에러가 발생했습니다."
    
    // 키체인
    static let saveTokenFail = "토큰 저장에 실패했습니다."
    static let readTokenFail = "토큰을 읽어오는데 실패했습니다."
    static let deleteTokenFail = "토큰 삭제에 실패했습니다."
    
    // oauth client 값
    static let readClientIdFail = "client ID를 설정해주세요."
    static let readClientSecretFail = "client secret을 설정해주세요."
    
    // UI
    static let userCellInitializeFail = "UserCell init에 실패했습니다"
    static let loadCellInitializeFail = "LoadCell init에 실패했습니다"
}
