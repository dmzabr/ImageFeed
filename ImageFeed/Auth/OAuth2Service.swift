//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by  Дмитрий on 11.03.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
}

final class OAuth2Service {
    private let tokenStorage = OAuth2TokenStorage()
    private let networkClient = NetworkClient()
    private let baseApiUrl = "https://unsplash.com"
    
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        
        networkClient.data(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = response.access_token
                    DispatchQueue.main.async {
                        completion(.success(response.access_token))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                print("Request error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        let baseURL = URL(string: "https://unsplash.com")
        
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"         // Используем знак ?, чтобы начать перечисление параметров запроса
            + "&&client_secret=\(Constants.secretKey)"    // Используем &&, чтобы добавить дополнительные параметры
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                           // Опираемся на основной или базовый URL, которые содержат схему и имя хоста
        ) else {
            print("Ошибка")
            return URLRequest(url: Constants.defaultBaseURL)
        }
        var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}
