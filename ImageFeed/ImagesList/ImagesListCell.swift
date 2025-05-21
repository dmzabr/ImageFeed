//
//  ImagesListCell.swift
//  Image Feed
//
//  Created by  Дмитрий on 18.11.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var cellImage: UIImageView!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction private func isTappedLike(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.isSelected = isLiked
    }
        func configure(with model: ImagesListCellModel) {
            setImage(with: model.imageURL)
            dateLabel.text = model.date
            setIsLiked(model.isLiked)
        }
    
    func setImage(with url: URL?) {
        cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Stub"),
            options: [.transition(.fade(0.3))]
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.setImage(UIImage(named: "gray_like"), for: .normal)
        likeButton.setImage(UIImage(named: "red_like"), for: .selected)
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

struct ImagesListCellModel {
    let imageURL: URL?
    let date: String
    let isLiked: Bool
}
