//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by  Дмитрий on 09.12.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded,  let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var didTapBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareButton: UIButton!
    
    var imageURL: URL?
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        
        loadImage()
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        updateImageViewSize()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func loadImage() {
        guard let imageURL else { return }
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
            self.imageView.kf.setImage(with: imageURL) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                
                switch result {
                case .success(let imageResult):
                    self.image = imageResult.image
                case .failure:
                    self.showError()
                }
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Попробуйте еще раз",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadImage()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func updateImageViewSize() {
        guard let image = image else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


