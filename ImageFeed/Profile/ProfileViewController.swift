//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 30.11.2024.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        makeLayout()
        fetchProfileData()
        profileImageView.layer.cornerRadius = 35
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(roundedRect: profileImageView.bounds,
                                byRoundingCorners: [.topLeft],
                                cornerRadii: CGSize(width: 61, height: 61))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        profileImageView.layer.mask = mask
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    deinit {
        removeObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 23, weight: .bold)
        ]
        
        label.attributedText = NSAttributedString(string: "Екатерина Новикова", attributes: attributes)
        
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YP Gray")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = UIFont.systemFont( ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YP White")
        
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        guard let image = UIImage(named: "Exit") else { return UIButton() }
        let button = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(Self.didTapExitButton))
        button.tintColor = #colorLiteral(red: 0.9771148562, green: 0.5101671815, blue: 0.4975126386, alpha: 1)
        
        return button
    }()
    
    @objc private func didTapExitButton() {
        let logOutService = ProfileLogoutService.shared
        logOutService.showLogoutAlert(from: self)
        
    }
    
    private func fetchProfileData() {
        guard let token = OAuth2TokenStorage().token else {
            print("Ошибка: токен отсутствует")
            return
        }
        
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateProfileUI(with: profile)
                    
                case .failure(let error):
                    print("Ошибка загрузки профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success:
                print("Аватарка успешно обновлена!")
            case .failure(let error):
                print("Ошибка загрузки аватарки: \(error.localizedDescription)")
                
                print("Получено уведомление об обновлении аватарки:", notification.userInfo ?? "пустой userInfo")
            }
        }
    }
    
    private func updateProfileUI(with profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio ?? "No bio available"
        
        if let avatarURL = ProfileImageService.shared.avatarURL {
            updateAvatar(with: avatarURL)
        }
    }
    
    private func updateAvatar(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }
    
    private func makeLayout() {
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
}
