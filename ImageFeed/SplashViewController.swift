//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 07.03.2025.
//


import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private var isProfileLoaded = false
    private let profileImageService = ProfileImageService.shared
    
    private let splashScreenLogoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            guard let authViewController = viewController else { return }
            authViewController.delegate = self
            
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarViewController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                fatalError("Invalid Configuration")
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                window.rootViewController = tabBarViewController
            } else {
                self.showAlert(with: "Ошибка", message: "Не удалось загрузить главный экран")
            }
        }
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SplashViewController {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauth2TokenStorage.token else {
            return
        }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        guard !isProfileLoaded else { return }
        isProfileLoaded = true
        
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                    
                    self.switchToTabBarViewController()
                }
            case .failure(let error):
                
                self.showAlert(with: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

extension SplashViewController {
    private func setting() {
        splashScreenLogoImageView.image = UIImage(named: "splash_screen_logo")
        splashScreenLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        splashScreenLogoImageView.contentMode = .scaleToFill
        
        view.addSubview(splashScreenLogoImageView)
        
        NSLayoutConstraint.activate([
            splashScreenLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
