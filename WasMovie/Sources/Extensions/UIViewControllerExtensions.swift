//
//  UIViewControllerExtensions.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit
import SCLAlertView

private var kLoadingAssociationKey: UInt8 = 0

extension UIViewController {

	var loading: SCLAlertViewResponder? {
		get {
			return objc_getAssociatedObject(self, &kLoadingAssociationKey) as? SCLAlertViewResponder
		}
		set(newValue) {
			let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
			objc_setAssociatedObject(self, &kLoadingAssociationKey, newValue, policy)
		}
	}

	func startLoading(_ title: String = L.wait, subtitle : String = L.loading) {
		if self.loading == nil {
			let app = SCLAlertView.SCLAppearance(showCloseButton: false)
			let loading = SCLAlertView(appearance: app)
			let colorStyle = UIColor.WMBlueColor().colorToUInt()
			self.loading = loading.showWait(title, subTitle: subtitle, colorStyle: colorStyle)
		}
	}

	func stopLoading(hasError error: Bool = false) {
		if let loading = self.loading {
			loading.setDismissBlock({
				self.loading = nil
				if error {
					self.showError()
					return
				}
			})
			loading.close()
		}
	}

	func showError() {
		let title		= L.sorry
		let subtitle	= L.somethingWentWrong
		SCLAlertView().showTitle(title, subTitle: subtitle, style: .error)
	}

	func preloadView() {
		let _ = view
	}
}

