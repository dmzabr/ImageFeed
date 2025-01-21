//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 30.11.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImageView = makeProfileImageView()
        let nameLabel = makeNameLabel()
        let nicknameLabel = makeNicknameLabel()
        let descriptionLabel = makeDescriptionLabel()
        let exitButton = makeExitButton()
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 99),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            
        ])
    }
    
    func makeProfileImageView() -> UIImageView {
        let profileImage = UIImage(named: "Photo")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }
    
    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 23)
        
        return label
    }
    
    func makeNicknameLabel() -> UILabel {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        label.font = .systemFont(ofSize: 13)
        
        return label
    }
    
    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Hello World!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        
        return label
        
    }
    
    func makeExitButton() -> UIButton {
        guard let image = UIImage(named: "Exit") else { return UIButton() }
        let button = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(Self.didTapExitButton))
        
        button.tintColor = #colorLiteral(red: 0.9771148562, green: 0.5101671815, blue: 0.4975126386, alpha: 1)
        
        return button
        
    }
    
    @objc func didTapExitButton() {
        
    }
    


}
