//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by  Дмитрий on 27.05.2025.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
