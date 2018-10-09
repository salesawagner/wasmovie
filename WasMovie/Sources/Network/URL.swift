//
//  URL.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

class URL {

	// MARK: - Util

	enum PhotoSize: String {
		case thumb = "w92"
		case small = "w185"
		case regular = "w500"
		case big = "w780"
	}
	
	// MARK: - Properties

	static var apiKey: String {
		return "2696829a81b1b5827d515ff121700838"
	}

	static var baseApiUrl: String {
		return "http://api.themoviedb.org/3"
	}

	static var basePhotoUrl: String {
		return "http://image.tmdb.org/t/p/"
	}

	// MARK: - Internal Methods

	class func search(_ query: String, page: Int = 1) -> String {
		var url = self.baseApiUrl
		url += "/search/movie"
		url += self.apiKey
		url += "&query=" + query
		url += "&page=" + "\(page)"
		return url
	}

	class func byId(_ id: Int) -> String {
		var url = self.baseApiUrl
		url += "/movie"
		url += "/\(id)"
		url += self.apiKey
		return url
	}

	class func photo(photoSize: URL.PhotoSize = .thumb, posterPath: String) -> String {
		var url = self.basePhotoUrl
		url += "/" + photoSize.rawValue
		url += "/" + posterPath
		return url
	}
}
