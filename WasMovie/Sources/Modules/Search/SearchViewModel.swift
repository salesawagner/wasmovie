//
//  SearchViewModel.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class SearchCellViewModel {
	var text: String
	init(text: String) {
		self.text = text
	}
}

protocol SearchViewModelProtocol {
	var searchCellViewModels: [SearchCellViewModel] { get }
	func loadSugestions(completion: Completion)
}

class SearchViewModel: SearchViewModelProtocol {

	// MARK: - Private Properties

	private var queries: [Query] = [] {
		didSet {
			var searchCellViewModels: [SearchCellViewModel] = []
			for query in self.queries {
				searchCellViewModels.append(SearchCellViewModel(text: query.text))
			}
			self.searchCellViewModels = searchCellViewModels
		}
	}

	// MARK: - Public Properties

	private(set) var searchCellViewModels: [SearchCellViewModel] = []

	// MARK: - Constructors

	func loadSugestions(completion: Completion) {
		let queries = Query.listAll().prefix(10)
		self.queries = queries.sorted(by: { $0.lastUpdate.compare($1.lastUpdate) == .orderedDescending })
		completion()
	}
}
