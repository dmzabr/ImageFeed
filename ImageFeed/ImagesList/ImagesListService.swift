//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by  Дмитрий on 19.05.2025.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    private static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage: OAuth2TokenStorage
    private let session: URLSession
    private let decoder = JSONDecoder()
    private var isLoading = false
    private var currentPage = 0
    
    init(tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage(), session: URLSession = .shared) {
        self.tokenStorage = tokenStorage
        self.session = session
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        
        guard let token = tokenStorage.token else {
            print("Ошибка: отсутствует токен")
            return
        }
        
        isLoading = true
        currentPage += 1
        
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print("Ошибка загрузки фотографий: \(error.localizedDescription)")
                return
            }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                //print("Ответ от сервера: \(jsonString)")
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Ошибка HTTP: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("Ошибка: нет данных")
                return
            }
            
            do {
                let photoResults = try self.decoder.decode([PhotoResult].self, from: data)
                let newPhotos = photoResults.map { self.convertToPhoto(from: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: nil,
                        userInfo: ["photos": self.photos] // Передаем обновленный массив
                    )
                }
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func convertToPhoto(from result: PhotoResult) -> Photo {
        let date = isoDateFormatter.date(from: result.createdAt ?? "" )
        return Photo(
            id: result.id,
            size: CGSize(width: result.width, height: result.height),
            createdAt: date,
            description: result.description,
            thumbImageURL: result.urls.thumb,
            largeImageURL: result.urls.full,
            isLiked: result.likedByUser
        )
    }
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host   = "api.unsplash.com"
        components.path   = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Токен не найден"])))
            return
        }
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "ImagesListService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Некорректный URL"])))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ImagesListService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Ошибка HTTP: \(httpResponse.statusCode)"])))
                }
                return
            }
            
            DispatchQueue.main.async {
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(from: photo)
                    
                    
                    self.photos[index] = newPhoto
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: nil,
                        userInfo: ["photos": self.photos]
                    )
                }
                completion(.success(()))
            }
        }
        
        task.resume()
    }
    
    private struct LikeResponse: Decodable {
        let photo: PhotoLikeState
        struct PhotoLikeState: Decodable {
            let liked_by_user: Bool
        }
    }
}


