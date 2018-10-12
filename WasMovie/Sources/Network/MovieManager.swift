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

	class func requestList(query: String, page: Int = 1, completion: @escaping CompletionList) -> Request? {
		let url = API.search(query, page: page)
		return Alamofire.request(url, method: .get).responseJSON { response in
			guard
				let value = response.result.value,
				let currentPage = JSON(value)["page"].int,
				let totalPages = JSON(value)["total_pages"].int else {
				completion(1, 1, [], false)
				return
			}

			let movies = Movie.arrayFromJson(JSON(value))
			completion(currentPage, totalPages, movies, true)
		}
	}

	class func requestById(_ id: Int, completion: @escaping CompletionDetail ) -> Request? {
		let url = API.byId(id)
		return Alamofire.request(url, method: .get).responseJSON { response in
			guard let value = response.result.value else {
				completion(nil, false)
				return
			}

			let movie = Movie(json: JSON(value))
			completion(movie, true)
		}
	}
}
