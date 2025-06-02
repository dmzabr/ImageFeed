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
    
    var onReloadCellCalled: (() -> Void)? // <— новое

    func updateTableView() {
        updateTableViewCalled = true
    }

    func reloadCell(at indexPath: IndexPath) {
        reloadCellCalled = true
        reloadIndexPath = indexPath
        onReloadCellCalled?() // <— уведомление теста
    }

    func updateTableView(oldCount: Int) {
        updateTableViewCalled = true
    }
}

