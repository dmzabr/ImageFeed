//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 27.05.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    
    func viewDidLoad()
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}
