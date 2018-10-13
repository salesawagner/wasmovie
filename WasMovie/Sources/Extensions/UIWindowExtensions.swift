//
//  UIWindowExtensions.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

extension UIWindow {
	
	// MARK: - Properties
	
	var visibleViewController: UIViewController? {
		return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
	}
	
	// MARK: - Public Methods
	
	class func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
		if let nc = vc as? UINavigationController {
			return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
		} else if let tc = vc as? UITabBarController {
			return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
		} else {
			if let pvc = vc?.presentedViewController {
				return UIWindow.getVisibleViewControllerFrom(pvc)
			} else {
				return vc
			}
		}
	}
}
