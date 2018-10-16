//
//  SearchViewModel.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class Query {
	var text: String
	init(text: String) {
		self.text = text
	}
	
	class func fake() -> [Query] {
		var queries: [Query] = []
		for i in 0...10 {
			queries.append(Query(text: "\(i)"))
		}
		
		return queries
	}
}

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
		self.queries = Query.fake()
	}
}
