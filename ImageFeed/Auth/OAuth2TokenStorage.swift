//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by  Дмитрий on 07.03.2025.
//


import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let tokenKey = "oauth_token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
