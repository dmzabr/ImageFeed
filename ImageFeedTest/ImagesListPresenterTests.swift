//
//  ImagesListPresenterTests.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//


import XCTest
@testable import ImageFeed

final class ImagesListPresenterTests: XCTestCase {

    func testViewDidLoadFetchesPhotos() {
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        let view = ImagesListViewControllerSpy()
        presenter.view = view as? any ImagesListViewControllerProtocol

        presenter.viewDidLoad()

        XCTAssertTrue(imagesListService.fetchPhotosNextPageCalled, "fetchPhotosNextPage должен быть вызван при viewDidLoad")
    }

    func testWillDisplayCellFetchesNextPage() {
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: imagesListService)

        let photos = (0..<10).map {
            Photo(id: "\($0)", size: CGSize(width: 100, height: 100), createdAt: nil, description: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)
        }
        imagesListService.setPhotos(photos)
        presenter.viewDidLoad() // чтобы скопировать photos в presenter.photos

        presenter.willDisplayCell(at: IndexPath(row: 9, section: 0))

        XCTAssertTrue(imagesListService.fetchPhotosNextPageCalled, "fetchPhotosNextPage должен быть вызван при показе последней ячейки")
    }


    func testDidTapLikeUpdatesPhotoAndReloadsCell() {
        let imagesListService = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        let view = ImagesListViewControllerSpy()
        presenter.view = view

        // Создаём фото
        let photo = Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: nil,
            description: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        )
        imagesListService.setPhotos([photo])
        presenter.viewDidLoad()

        // Ожидаем вызова reloadCell
        let expectation = self.expectation(description: "Ожидание вызова reloadCell")
        view.onReloadCellCalled = {
            expectation.fulfill()
        }

        // Действие
        presenter.didTapLike(at: IndexPath(row: 0, section: 0))

        // Ожидание
        waitForExpectations(timeout: 1.0)

        // Проверки
        XCTAssertTrue(view.reloadCellCalled, "reloadCell должен быть вызван после смены лайка")
        XCTAssertTrue(imagesListService.photos[0].isLiked, "Фото должно быть залайкано")
    }

}



