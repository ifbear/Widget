//
//  UIApplication+Extensions.swift
//  Widget
//
//  Created by dexiong on 2023/5/5.
//

import Foundation
import UIKit

extension UIApplication {
    internal static var topViewController: UIViewController? {
        let windowScenes = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
        guard let keyWindow = windowScenes.compactMap({ $0.windows.first(where: { $0.isKeyWindow }) }).first else { return nil }
        var topViewController = keyWindow.rootViewController
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navi = topViewController as? UINavigationController {
                topViewController = navi.topViewController
            } else if let tabVC = topViewController as? UITabBarController {
                topViewController = tabVC.selectedViewController
            } else {
                break
            }
        }
        return topViewController
    }
}
