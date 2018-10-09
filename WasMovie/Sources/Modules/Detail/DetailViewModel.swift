//
//  DetailViewModel.swift
//  WasMovie
//
//  Created by Wagner Sales on 09/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation

class DetailViewModel: MovieViewModelProtocol {

	// MARK: - Properties

	let viewTitle = L.details

	let id: Int
	let title: String
	let posterPath: String

	// MARK: - Constructors

	required init(movie: Movie) {
		self.id = movie.id
		self.title = movie.title
		self.posterPath = movie.posterPath
	}
}
