//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
}
