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

	var viewModel: ListViewModelProtocol = ListViewModel()
	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(self.didRefresh(_:)), for: .valueChanged)
		return refreshControl
	}()
	private let loadingPagination = UIActivityIndicatorView(style: .gray)
	private var query: String = "Batman"

	// MARK: - Private Methods

	private func setups() {
		self.setupTitle()
		self.setuptableView()
	}

	private func setupTitle() {
		self.title = self.viewModel.viewTitle
	}

	private func setuptableView() {
		self.tableView.sectionFooterHeight = 0
		self.tableView.showsVerticalScrollIndicator = false
		self.tableView.showsHorizontalScrollIndicator = false
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.separatorColor = UIColor.clear
		self.tableView.addSubview(self.refreshControl)
	}

	@objc func didRefresh(_ refreshControl: UIRefreshControl) {
		self.loadMovies(useLoading: false) { success in
			self.refreshControl.endRefreshing()
		}
	}

	private func loadMovies(useLoading: Bool = true,
							loadType: ListViewModel.LoadType = .refresh,
							completion: CompletionSuccess? = nil) {

		if useLoading {
			self.startLoading()
		}

		self.viewModel.loadMovies(query: self.query, loadType: loadType) { success in
			self.tableView.reloadData()
			self.stopLoading(hasError: !success)
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
		if lastRowIndex == indexPath.row && self.viewModel.hasNextPage {

			self.loadingPagination.startAnimating()
			self.loadMovies(useLoading: false, loadType: .nextPage) { success in
				self.loadingPagination.stopAnimating()
			}

		}
	}
}
