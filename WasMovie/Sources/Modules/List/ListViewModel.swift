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
	var cellViewModels: [CellViewModel] { get }

	func loadMovies(query: String, completion: @escaping CompletionSuccess)
	func createDetailViewModel(index: Int) -> DetailViewModel
}

class ListViewModel: ListViewModelProtocol {

	// MARK: - Private Properties
	
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
	var cellViewModels: [CellViewModel] = []

	// MARK: - ListViewModelProtocol Methods

	func loadMovies(query: String, completion: @escaping CompletionSuccess) {
		let _ = MovieManager.requestList(query: query, completion: { (success, movies) in
			if success {
				self.movies = movies ?? []
				completion(true)
			} else {
				completion(false)
			}
		})
	}

	func createDetailViewModel(index: Int) -> DetailViewModel {
		let movie = self.movies[index]
		return DetailViewModel(movie: movie)
	}
}
