//
//  Keychain.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/08.
//

import Foundation

/*
 참고:
 키체인 https://mini-min-dev.tistory.com/114
 api key 숨기기 https://nareunhagae.tistory.com/44
 */

protocol KeyChainDelegate {
    func didSignIn()
}

struct KeyChain {
    static var shared = KeyChain()
    var delegate: KeyChainDelegate?
    
    func create(token: String) {
        let query: NSDictionary = [ kSecClass: kSecClassGenericPassword,
                              kSecAttrAccount: KeyChainKey.accessToken,
                                kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            delegate?.didSignIn()
        } else {
            print(ErrorMessage.saveTokenFail)
        }
    }
    
    
    func read() -> String? {
        let query: NSDictionary = [ kSecClass: kSecClassGenericPassword,
                              kSecAttrAccount: KeyChainKey.accessToken,
                               kSecReturnData: kCFBooleanTrue as Any,
                               kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else {
                return nil
            }
        } else {
            print("\(ErrorMessage.readTokenFail), status code = \(status)")
            return nil
        }
    }
    
    
    func delete() {
        let query: NSDictionary = [ kSecClass: kSecClassGenericPassword,
                              kSecAttrAccount: KeyChainKey.accessToken
        ]
        let status = SecItemDelete(query)
        
        if status == noErr {
            print("\(ErrorMessage.deleteTokenFail), status code = \(status)")
        }
    }
}
