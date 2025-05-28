//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewCalled = false
    var reloadCellCalled = false
    var reloadIndexPath: IndexPath?

    func updateTableView() {
        updateTableViewCalled = true
    }

    func reloadCell(at indexPath: IndexPath) {
        reloadCellCalled = true
        reloadIndexPath = indexPath
    }

    func updateTableView(oldCount: Int) {
        updateTableViewCalled = true
    }
}
