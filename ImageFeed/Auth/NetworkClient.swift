//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by  Дмитрий on 11.03.2025.
//

import Foundation
import UIKit

//struct NetworkClient {
//    private enum NetworkError: Error {
//        case codeError
//    }
//    
//    func data(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                handler(.failure(error))
//                return
//            }
//            
//            if let response = response as? HTTPURLResponse,
//                response.statusCode < 200 || response.statusCode >= 300 {
//                handler(.failure(NetworkError.codeError))
//                return
//            }
//            
//            guard let data = data else { return }
//            handler(.success(data))
//        }
//        
//        task.resume()
//    }
//}


struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    func data(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        // let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                handler(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            handler(.success(data))
        }
        task.resume()
    }
}
