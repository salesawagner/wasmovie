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
	private var refreshControl: UIRefreshControl!
	private var loadingPagination: UIActivityIndicatorView!
	private var query: String = "" {
		didSet {
			guard oldValue != self.query else {
				return
			}
			self.setupTitle()
			self.loadMovies()
		}
	}

	// MARK: - Private Methods

	private func setups() {
		self.setupTitle()
		self.setupNavigationBar()
		self.setupRefreshControl()
		self.setuptableView()
		self.setupLoadingPagination()
	}

	private func setupTitle() {
		if !self.query.isEmpty {
			self.title = self.query
		} else {
			self.title = self.viewModel.viewTitle
		}
	}
	
	private func setupNavigationBar() {
		let selector = #selector(self.showSearch)
		let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: selector)
		self.navigationItem.rightBarButtonItem = searchButton
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
		self.tableView.addSubview(self.refreshControl)
		self.tableView.placeholderDelegate = self
		self.tableView.placeholder(isShow: false)
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
		let searchViewController = SearchViewController(searchString: self.query)
		searchViewController.delegate = self
		let navigationController = UINavigationController(rootViewController: searchViewController)
		self.present(navigationController, animated: true, completion: nil)
	}

	private func loadMovies(useLoading: Bool = true,
							loadType: ListViewModel.LoadType = .refresh,
							completion: CompletionSuccess? = nil) {

		if useLoading {
			self.startLoading()
		}

		self.viewModel.loadMovies(query: self.query, loadType: loadType) { success in
			self.reloadData()
			self.stopLoading(hasError: !success)
			completion?(success)
		}

	}

	private func reloadData() {
		self.tableView.reloadData()
		self.tableView.placeholder(isShow: self.viewModel.cellViewModels.count == 0, animate: true)
	}

	// MARK: - Internal Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setups()
		self.loadMovies()
	}
}

// MARK: - SearchViewControllerDelegate

extension ListViewController: SearchViewControllerDelegate {
	func searchWillClose(searchString: String) {
		self.query = searchString
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
//		TODO: Criar tela de deatalhes
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

// MARK: - UITableViewPlaceholderDelegate

extension ListViewController: UITableViewPlaceholderDelegate {
	func placeholderViewModel(in tableView: UITableView) -> PlaceholderViewModel {
		let image = UIImage(named: "smile-sad")
		let placeholder = PlaceholderViewModel(image: image, title: L.sorry, message: L.emptyMessage)
		return placeholder
	}
}
