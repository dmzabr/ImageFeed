//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableView()
    func reloadCell(at indexPath: IndexPath)
    func updateTableView(oldCount: Int)
}
