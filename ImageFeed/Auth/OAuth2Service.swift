//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by  Дмитрий on 11.03.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    private let tokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    static let shared = OAuth2Service()
    private var activeRequests: [String: [(Result<String, Error>) -> Void]] = [:]
    
    init(task: URLSessionTask? = nil, lastCode: String? = nil) {
        self.task = task
        self.lastCode = lastCode
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        if lastCode == code {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let tokenResponse):
//                self.tokenStorage.token = tokenResponse.accessToken
                print("Успешно получен и сохранен токен: \(tokenResponse.accessToken)")
                completion(.success(tokenResponse.accessToken))
            case .failure(let error):
                print("[OAuth2Service.fetchOAuthToken]: Ошибка получения токена — \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    private func complete(code: String, with result: Result<String, Error>) {
         let completions = self.activeRequests[code]
         self.activeRequests[code] = nil
         completions?.forEach { $0(result) }
     }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Ошибка: невозможно создать базовый URL")
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("Ошибка: невозможно создать URL запроса")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}


