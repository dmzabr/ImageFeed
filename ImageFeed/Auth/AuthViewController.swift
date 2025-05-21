
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let authService = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var isLoading = false
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        view.backgroundColor = UIColor(named: "YP Black (iOS)")
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black (iOS)")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
            webViewViewController.modalPresentationStyle = .fullScreen
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        //dismiss(animated: true)
        showLoading()
        
        authService.fetchOAuthToken(code: code) { [weak self] token in
            guard let self = self else { return }
            
            self.hideLoading()
            switch token {
            case .success(let result):
                self.oauth2TokenStorage.token = result
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("[AuthViewController]: Ошибка авторизации - \(error.localizedDescription)")
                let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

extension AuthViewController {
    private func showLoading() {
        self.isLoading = true
        UIBlockingProgressHUD.show()
        
    }
    
    private func hideLoading() {
        self.isLoading = false
        ProgressHUD.dismiss()

    }
}
