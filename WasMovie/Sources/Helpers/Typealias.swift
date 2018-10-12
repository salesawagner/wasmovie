//
//  Typealias.swift
//  WasMovie
//
//  Created by Wagner Sales on 08/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

typealias Completion = () -> Void
typealias CompletionImage = (_ image: UIImage?) -> Void
typealias CompletionSuccess = (_ success: Bool) -> Void
typealias CompletionList = (_ page: Int, _ totalPages: Int, _ movies: [Movie], _ success: Bool) -> Void
typealias CompletionDetail = (_ movie: Movie?, _ success: Bool) -> Void
