//
//  API.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

class API {

	// MARK: - Util

	enum PhotoSize: String {
		case thumb = "w92"
		case small = "w185"
		case regular = "w500"
		case big = "w780"
	}
	
	// MARK: - Private Properties

	static private var key: String {
		return "2696829a81b1b5827d515ff121700838"
	}

	static private var baseURL: String {
		return "http://api.themoviedb.org/3"
	}

	static private var basePhotoURL: String {
		return "http://image.tmdb.org/t/p/"
	}

	// MARK: - Internal Methods

	class func search(_ query: String, page: Int) -> String {
		var url = self.baseURL
		url += "/search/movie"
		url += "/?api_key=" + self.key
		url += "&query=" + query
		url += "&page=" + "\(page)"
		return url
	}
	
	class func discover(page: Int) -> String {
		var url = self.baseURL
		url += "/discover/movie"
		url += "/?api_key=" + self.key
		url += "&sort_by=popularity.desc"
		url += "&page=" + "\(page)"
		return url
	}

	class func byId(_ id: Int) -> String {
		var url = self.baseURL
		url += "/movie"
		url += "/\(id)"
		url += "/?api_key=" + self.key
		return url
	}

	class func poster(photoSize: API.PhotoSize = .thumb, posterPath: String) -> String {
		var url = self.basePhotoURL
		url += "/" + photoSize.rawValue
		url += "/" + posterPath
		return url
	}
}
