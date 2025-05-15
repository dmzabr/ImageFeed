//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 31.01.2025.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
        func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    }

final class AuthViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 16
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { return }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton () {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) {
            DispatchQueue.main.async {
                UIBlockingProgressHUD.show()
            }
            self.oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
                
                switch result {
                case .success(let token):
                    print("Token received: \(token)")
                    self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                case .failure(let error):
                    print("Failed to fetch token: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showAlert() // Показать алерт при ошибке
                    }
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
