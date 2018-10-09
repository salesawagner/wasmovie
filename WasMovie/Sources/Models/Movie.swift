//
//  Movie.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {

	let id: Int
	let title: String
	let posterPath: String
	let overview: String

	init?(json: JSON) {
		self.id = json["id"].intValue
		self.title = json["title"].stringValue
		self.posterPath = json["poster_path"].stringValue
		self.overview = json["overview"].stringValue
	}
	
	class func arrayFromJson(_ json: JSON) -> [Movie] {
		guard let results = json["results"].array else { return [] }

		var movies: [Movie] = []
		for movieJSON in results {
			if let movie = Movie(json: movieJSON) {
				movies.append(movie)
			}
		}

		return movies
	}
}
