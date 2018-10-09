//
//  Typealias.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

typealias Completion = () -> Void
typealias CompletionSuccess = (_ success: Bool) -> Void
typealias CompletionSuccessMovies = (_ success: Bool, _ movies: [Movie]?) -> Void
typealias CompletionSuccessMovie = (_ success: Bool, _ movie: Movie?) -> Void
