//
//  ListViewModel.swift
//  WasMovie
//
//  Created by Wagner Sales on 09/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation

protocol ListViewModelProtocol {

	var viewTitle: String { get }
	var searchPlaceHolder: String { get }
	var cellViewModels: [CellViewModel] { get }
	var hasNextPage: Bool { get }

	func loadMovies(query: String, loadType: ListViewModel.LoadType?, completion: @escaping CompletionSuccess)
	func createDetailViewModel(index: Int) -> DetailViewModel
}

class ListViewModel: ListViewModelProtocol {

	enum LoadType {
		case refresh
		case nextPage
	}

	// MARK: - Private Properties

	private var currentPage: Int = 1
	private var totalPages: Int = 1
	private var nextPage: Int {
		return self.currentPage == self.totalPages ? self.currentPage : self.currentPage + 1
	}
	private var movies: [Movie] = [] {
		didSet {
			var cellViewModels: [CellViewModel] = []
			for movie in self.movies {
				cellViewModels.append(CellViewModel(movie: movie))
			}
			self.cellViewModels = cellViewModels
		}
	}

	// MARK: - Properties

	let viewTitle: String = L.list
	let searchPlaceHolder: String = L.search
	var cellViewModels: [CellViewModel] = []
	var hasNextPage: Bool {
		return self.nextPage < self.totalPages
	}

	// MARK: - ListViewModelProtocol Methods

	func loadMovies(query: String, loadType: LoadType? = .refresh, completion: @escaping CompletionSuccess) {

		if loadType == .refresh {
			self.currentPage = 1
			self.totalPages = 1
		}

		let _ = MovieManager.requestList(query: query, page: self.nextPage) { (currentPage, totalPages, movies, success) in
			if success {
				self.currentPage = currentPage
				self.totalPages = totalPages
				
				if loadType == .refresh {
					self.movies = movies
				} else if loadType == .nextPage {
					self.movies.append(contentsOf: movies)
				}
				
				completion(true)
			} else {
				completion(false)
			}
		}
	}

	func createDetailViewModel(index: Int) -> DetailViewModel {
		let movie = self.movies[index]
		return DetailViewModel(movie: movie)
	}
}
