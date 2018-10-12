//
//  CellViewModel.swift
//  WasMovie
//
//  Created by Wagner Sales on 09/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation

class CellViewModel: MovieViewModelProtocol {

	// MARK: - Properties

	let id: Int
	let title: String
	let releaseDate: String
	let overview: String
	let posterPath: String

	// MARK: - Constructors

	required init(movie: Movie) {
		self.id = movie.id
		self.title = movie.title
		self.releaseDate = "10/10/1984" // TODO:
		self.overview = movie.overview
		self.posterPath = movie.posterPath
	}
}
