//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 31.01.2025.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    var presenter: (any WebViewPresenterProtocol)?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressViewBar: UIProgressView!
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewViewController loaded")
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
             }
        )
    }
    
//    init(presenter: WebViewPresenterProtocol) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//        self.presenter?.view = self
//    }
//    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        estimatedProgressObservation = nil
    }
    
    func setProgressValue(_ newValue: Float) {
        progressViewBar.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressViewBar.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = Constants.unsplashAuth
}
