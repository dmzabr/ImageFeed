//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by  Дмитрий on 19.05.2025.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?

    func fetchPhotosNextPage() {
        // если уже идёт запрос — выходим
        if task != nil { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        let perPage  = 10
        
        guard let request = makePhotosRequest(page: nextPage, perPage: perPage) else {
            assertionFailure("Не удалось создать request")
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { [weak self]
            (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            defer { self.task = nil }
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { self.convertToPhoto(from: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
            case .failure(let error):
                print("[ImagesListService.fetch]: \(error)")
            }
        }
        task?.resume()
    }
    
    private func convertToPhoto(from result: PhotoResult) -> Photo {
        let size = CGSize(width: result.width, height: result.height)
        let createdAt = result.createdAt.flatMap { ISO8601DateFormatter().date(from: $0) } ?? Date()
        return Photo(
            id: result.id,
            size: size,
            createdAt: createdAt,
            description: result.description,
            thumbImageURL: result.urls.thumb,
            largeImageURL: result.urls.full,
            isLiked: result.likedByUser
        )
    }
    
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

}

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: PhotoURLs
    let likedByUser: Bool
    
}

struct PhotoURLs: Codable {
    let thumb: String
    let full: String
}

extension ImagesListService {
    func convertToPhotos(from photoResults: [PhotoResult]) -> [Photo] {
        return photoResults.compactMap { photoResult in
            let createdAt = photoResult.createdAt.flatMap {
                ISO8601DateFormatter().date(from: $0)
            }
            
            let size = CGSize(width: photoResult.width, height: photoResult.height)
            
            return Photo(
                id: photoResult.id,
                size: size,
                createdAt: createdAt,
                description: photoResult.description,
                thumbImageURL: photoResult.urls.thumb,
                largeImageURL: photoResult.urls.full,
                isLiked: photoResult.likedByUser
            )
        }
    }
}
