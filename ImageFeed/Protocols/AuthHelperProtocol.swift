//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 28.05.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
