//
//  UITableViewExtensions.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

private var kTableViewPlaceholderDelegateKey: UInt8 = 0

protocol UITableViewPlaceholderDelegate: class {
	func placeholderViewModel(in tableView: UITableView) -> PlaceholderViewModel
}

extension UITableView {

	// MARK: - Private Methods

	private func setupPlaceholder(with viewModel: PlaceholderViewModel) {
		guard let visibleViewController = UIViewController.visible else { return }

		let placeholder = PlaceholderView(frame: visibleViewController.view.frame)
		placeholder.setupUI(with: viewModel)
		self.backgroundView = placeholder
	}
	
	// MARK: - Internal Properties
	
	weak var placeholderDelegate: UITableViewPlaceholderDelegate? {
		get {
			return objc_getAssociatedObject(self, &kTableViewPlaceholderDelegateKey) as? UITableViewPlaceholderDelegate
		}
		set(newValue) {
			let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
			objc_setAssociatedObject(self, &kTableViewPlaceholderDelegateKey, newValue, policy)

			// DidSet
			if let newValue = newValue {
				let viewModel = newValue.placeholderViewModel(in: self)
				self.setupPlaceholder(with: viewModel)
			}
		}
	}

	func placeholder(isShow: Bool, animate: Bool = false) {
		guard isShow else {
			self.backgroundView?.alpha = 0.0
			return
		}
		
		if animate {
			self.backgroundView?.alpha = 0.0
			UIView.animate(withDuration: 0.3) {
				self.backgroundView?.alpha = 1.0
			}
		} else {
			self.backgroundView?.alpha = 1.0
		}
	}
}
