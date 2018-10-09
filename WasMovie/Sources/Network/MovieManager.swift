//
//  MovieManager.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MovieManager {

	class func requestList(query: String, page: Int = 1, completion: @escaping CompletionSuccessMovies) -> Request? {
		let url = API.search(query, page: page)
		return Alamofire.request(url, method: .get).responseJSON { response in
			guard let value = response.result.value else {
				completion(false, nil)
				return
			}

			let movies = Movie.arrayFromJson(JSON(value))
			completion(true, movies)
		}
	}

	class func requestById(_ id: Int, completion: @escaping CompletionSuccessMovie ) -> Request? {
		let url = API.byId(id)
		return Alamofire.request(url, method: .get).responseJSON { response in
			guard let value = response.result.value else {
				completion(false, nil)
				return
			}

			let movie = Movie(json: JSON(value))
			completion(true, movie)
		}
	}
}
