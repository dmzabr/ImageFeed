//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 31.01.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
        func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    }

final class AuthViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
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
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async{
            self.delegate?.authViewController(self, didAuthenticateWithCode: code)

        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
