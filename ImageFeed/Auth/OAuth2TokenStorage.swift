//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by  Дмитрий on 07.03.2025.
//


import Foundation

final class OAuth2TokenStorage {
    let tokenKey = "authTokenKey"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
}
