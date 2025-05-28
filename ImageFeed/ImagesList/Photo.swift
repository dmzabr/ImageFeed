//
//  Photo.swift
//  ImageFeed
//
//  Created by  Дмитрий on 21.05.2025.
//

import Foundation

public struct Photo {
    public let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool

    public init(from photo: Photo) {
        self.id = photo.id
        self.size = photo.size
        self.createdAt = photo.createdAt
        self.description = photo.description
        self.thumbImageURL = photo.thumbImageURL
        self.largeImageURL = photo.largeImageURL
        self.isLiked = photo.isLiked
    }
    public init(
        id: String,
        size: CGSize,
        createdAt: Date?,
        description: String?,
        thumbImageURL: String,
        largeImageURL: String,
        isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.description = description
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}

public struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: PhotoURLs
    let likedByUser: Bool
}

public struct PhotoURLs: Codable {
    let thumb: String
    let full: String
}
