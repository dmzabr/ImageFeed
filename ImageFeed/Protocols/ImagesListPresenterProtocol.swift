//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func willDisplayCell(at indexPath: IndexPath)
    func didTapLike(at indexPath: IndexPath)
    func updateTableView(oldCount: Int)
    func reloadCell(at indexPath: IndexPath)
}
