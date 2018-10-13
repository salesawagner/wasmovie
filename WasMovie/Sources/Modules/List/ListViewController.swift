//
//  ListViewController.swift
//  WasMovie
//
//  Created by Wagner Sales on 09/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

	// MARK: - Properties

	@IBOutlet weak var tableView: UITableView!

	let viewModel: ListViewModelProtocol = ListViewModel()
	private var resultsController: UITableViewController!
	private var searchController: UISearchController!
	private var refreshControl: UIRefreshControl!
	private var loadingPagination: UIActivityIndicatorView!
	private var query: String = "" {
		didSet {
			self.loadMovies()
		}
	}

	// MARK: - Private Methods

	private func setups() {
		self.setupTitle()
		self.setupSearchBar()
		self.setupRefreshControl()
		self.setuptableView()
		self.setupLoadingPagination()
	}

	private func setupTitle() {
		self.title = self.viewModel.viewTitle
	}
	
	private func setupSearchBar() {
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.dimsBackgroundDuringPresentation = false
		self.searchController.hidesNavigationBarDuringPresentation = false
		
		self.searchController.searchBar.placeholder = self.viewModel.searchPlaceHolder
		self.searchController.searchBar.delegate = self
		self.searchController.searchBar.sizeToFit()
		self.searchController.searchBar.searchBarStyle = .minimal
		self.searchController.searchBar.setShowsCancelButton(true, animated: false)
		self.searchController.searchBar.isTranslucent = false

		self.extendedLayoutIncludesOpaqueBars = true
		self.definesPresentationContext = false

		self.hideSearch()
	}

	private func setupRefreshControl() {
		let selector = #selector(self.didRefresh(_:))
		self.refreshControl = UIRefreshControl()
		self.refreshControl.addTarget(self, action: selector, for: .valueChanged)
	}

	private func setuptableView() {
		self.tableView.sectionFooterHeight = 0
		self.tableView.showsVerticalScrollIndicator = false
		self.tableView.showsHorizontalScrollIndicator = false
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.separatorColor = UIColor.clear
		self.tableView.addSubview(self.refreshControl)
	}

	private func setupLoadingPagination() {
		self.loadingPagination = UIActivityIndicatorView(style: .gray)
	}

	@objc func didRefresh(_ refreshControl: UIRefreshControl) {
		self.loadMovies(useLoading: false) { success in
			self.refreshControl.endRefreshing()
		}
	}

	@objc private func showSearch() {
		self.navigationItem.titleView = self.searchController.searchBar
		self.navigationItem.rightBarButtonItem = nil
	}

	@objc private func hideSearch() {
		if let text = self.searchController.searchBar.text, !text.isEmpty {
			return
		}

		self.navigationItem.titleView = nil
		
		let selector = #selector(self.showSearch)
		let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: selector)
		self.navigationItem.rightBarButtonItem = searchButton
	}

	private func startLoading() {
		// TODO:
	}
	private func stopLoading(success: Bool = true) {
		// TODO:
	}

	private func loadMovies(useLoading: Bool = true,
							loadType: ListViewModel.LoadType = .refresh,
							completion: CompletionSuccess? = nil) {

		if useLoading {
			self.startLoading()
		}

		self.viewModel.loadMovies(query: self.query, loadType: loadType) { success in
			self.tableView.reloadData()
			self.stopLoading(success: success)
			completion?(success)
		}

	}

	// MARK: - Internal Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setups()
		self.loadMovies()
	}
}

// MARK: - UITableViewDataSource

extension ListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.query = searchBar.text ?? ""
		self.hideSearch()
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		self.query = ""
		self.hideSearch()
	}
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.cellViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var cell: UITableViewCell!
		let identifier: String = ListTableViewCell.identifier

		if let listCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListTableViewCell {
			let dataSource = self.viewModel.cellViewModels
			let cellViewModel = dataSource[indexPath.row]
			listCell.setup(withCellViewModel: cellViewModel)
			cell = listCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
		}

		return cell
	}
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailViewModel = self.viewModel.createDetailViewModel(index: indexPath.row)
		print(detailViewModel.title)
//		TODO:
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return self.viewModel.hasNextPage ? self.loadingPagination : nil
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

		let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
		guard lastRowIndex == indexPath.row && self.viewModel.hasNextPage else { return }

		self.loadingPagination.startAnimating()
		self.loadMovies(useLoading: false, loadType: .nextPage) { success in
			self.loadingPagination.stopAnimating()
		}

	}
}
