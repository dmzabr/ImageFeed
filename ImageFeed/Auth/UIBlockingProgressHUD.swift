//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by  Дмитрий on 13.04.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.animate()
        }
    }
    
    static func blockUI() {
        window?.isUserInteractionEnabled = false
    }
    
    static func unblockUI() {
        window?.isUserInteractionEnabled = true
    }
}
