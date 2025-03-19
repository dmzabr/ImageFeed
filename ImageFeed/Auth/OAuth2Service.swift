//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by  Дмитрий on 11.03.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    private let tokenStorage = OAuth2TokenStorage()
    private let networkClient = NetworkClient()
    private let baseApiUrl = "https://unsplash.com"
    
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Ошибка при создании запроса")
            return
        }
        
        networkClient.data(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = response.accessToken
                    DispatchQueue.main.async {
                        completion(.success(response.accessToken))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Request error: \(error)")
                    completion(.failure(error))
                }
            }
        }
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
