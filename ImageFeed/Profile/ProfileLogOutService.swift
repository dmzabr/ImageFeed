//
//  ProfileLogOutService.swift
//  ImageFeed
//
//  Created by  Дмитрий on 21.05.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
       cleanCookies()
       clearToken()
       
       DispatchQueue.main.async {
           guard let window = UIApplication.shared.windows.first else { return }
           window.rootViewController = SplashViewController()
           window.makeKeyAndVisible()
       }
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
    
    private func clearToken() {
        OAuth2TokenStorage().token = nil
    }
    
    func showLogoutAlert (from viewController: UIViewController) {
       let alert = UIAlertController(title: "Выход из аккаунта", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
           
           let logoutAction = UIAlertAction(title: "Да", style: .destructive) { _ in
               ProfileLogoutService.shared.logout()
           }
           
           let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
           
           alert.addAction(logoutAction)
           alert.addAction(cancelAction)
           
       viewController.present(alert, animated: true)
   }
}
