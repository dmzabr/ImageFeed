//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by  Дмитрий on 22.05.2025.
//

protocol ProfileViewControllerProtocol: AnyObject {
    func updateAvatar(with urlString: String)
    func updateProfile(with profile: Profile)
}
