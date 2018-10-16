//
//  SearchViewController.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate {
	func searchWillClose(searchString: String)
}

class SearchViewController: UITableViewController {
	
	// MARK: - Properties
	
	let searchBar: UISearchBar = UISearchBar()
	let viewModel: SearchViewModelProtocol = SearchViewModel()
	var delegate: SearchViewControllerDelegate?
	var searchString: String = ""
	
	// MARK: - Constructors
	
	init(searchString: String) {
		self.searchString = searchString
		super.init(style: .plain)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Overrides
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setups()
	}
	
	// MARK: - Private Methods
	
	private func setups() {
		self.setupSearchBar()
		self.setupTableView()
	}

	private func setupSearchBar() {
		self.searchBar.searchBarStyle = .minimal
		self.searchBar.placeholder = L.search
		self.searchBar.sizeToFit()
		self.searchBar.isTranslucent = false
		self.searchBar.backgroundImage = UIImage()
		self.searchBar.delegate = self
		self.searchBar.text = self.searchString
		self.searchBar.showsCancelButton = true

		if let cancelButton: UIButton = searchBar.value(forKey: "_cancelButton") as? UIButton {
			cancelButton.isEnabled = true
		}

		self.navigationItem.titleView = self.searchBar
	}

	private func setupTableView() {
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		self.viewModel.loadSugestions {
			self.tableView.reloadData()
		}
	}

	@objc private func closeView() {
		self.delegate?.searchWillClose(searchString: self.searchString)
		self.dismiss(animated: true, completion: nil)
	}
}

// MARK: - UITableViewDataSource

extension SearchViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.searchCellViewModels.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellViewModel = self.viewModel.searchCellViewModels[indexPath.row]
		let identifier: String = "Cell"
		var cell: UITableViewCell!
		
		if let myCell = tableView.dequeueReusableCell(withIdentifier: identifier) {
			cell = myCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
		}

		cell.textLabel?.text = cellViewModel.text

		return cell
	}
}

extension SearchViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cellViewModel = self.viewModel.searchCellViewModels[indexPath.row]
		self.searchString = cellViewModel.text
		self.closeView()
	}
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		defer {
			self.closeView()
		}
		
		guard let searchString = self.searchBar.text else {
			return
		}
		
		self.searchString = searchString
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchString = ""
		self.closeView()
	}
}
