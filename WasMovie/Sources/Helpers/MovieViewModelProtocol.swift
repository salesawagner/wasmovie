//
//  MovieViewModelProtocol.swift
//  WasMovie
//
//  Created by Wagner Sales on 09/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import Foundation

protocol MovieViewModelProtocol {
	var id: Int { get }
	init(movie: Movie)
}
