//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
