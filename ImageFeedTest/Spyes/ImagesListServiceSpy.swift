//
//  ImagesListServiceSpy.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    private(set) var fetchPhotosNextPageCalled = false
    private(set) var changeLikeCalled = false
    private(set) var lastPhotoId: String?
    private(set) var lastIsLike: Bool?
    
    private(set) var photosInternal: [Photo] = []
    var photos: [Photo] {
        get { photosInternal }
        set { photosInternal = newValue }
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        lastPhotoId = photoId
        lastIsLike = isLike

        if let index = photosInternal.firstIndex(where: { $0.id == photoId }) {
            let old = photosInternal[index]
            let updated = Photo(
                id: old.id,
                size: old.size,
                createdAt: old.createdAt,
                description: old.description,
                thumbImageURL: old.thumbImageURL,
                largeImageURL: old.largeImageURL,
                isLiked: isLike
            )
            photosInternal[index] = updated
        }

        completion(.success(()))
    }

    func setPhotos(_ photos: [Photo]) {
        self.photosInternal = photos
    }
}
