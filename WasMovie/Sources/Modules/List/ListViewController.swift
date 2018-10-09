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
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(self.didRefresh(_:)), for: .valueChanged)
		return refreshControl
	}()

	// MARK: - Private Methods

	private func setups() {
		self.setupTitle()
		self.setuptableView()
	}

	private func setupTitle() {
		self.title = self.viewModel.viewTitle
	}

	private func setuptableView() {
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.sectionFooterHeight = 0
		self.tableView.tableFooterView = UIView()
		self.tableView.showsVerticalScrollIndicator = false
		self.tableView.showsHorizontalScrollIndicator = false
		self.tableView.backgroundColor = UIColor.clear
		self.tableView.addSubview(self.refreshControl)
	}

	@objc func didRefresh(_ refreshControl: UIRefreshControl) {
		self.loadMovies(useLoading: false) { success in
			self.refreshControl.endRefreshing()
		}
	}

	private func startLoading() { }
	private func stopLoading(success: Bool = true) { }

	private func loadMovies(useLoading: Bool = true, completion: CompletionSuccess? = nil) {
		if useLoading {
			self.startLoading()
		}

		self.viewModel.loadMovies(query: "batman") { success in
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

extension ListViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.cellViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell!

		if let myCell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
			let dataSource = self.viewModel.cellViewModels
			let cellViewModel = dataSource[indexPath.row]

			myCell.textLabel?.text = cellViewModel.title
			cell = myCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
		}

		return cell
	}
}

extension ListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailViewModel = self.viewModel.createDetailViewModel(index: indexPath.row)
		print(detailViewModel.title)
	}
}
