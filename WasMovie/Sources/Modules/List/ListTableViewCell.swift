//
//  ListTableViewCell.swift
//  WasMovie
//
//  Created by Wagner Sales on 11/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

	// MARK: - Static Properties

	static let identifier: String = String(describing: ListTableViewCell.self)

	// MARK: - Properties

	@IBOutlet weak var shadowView: UIView!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var posterImageView: UIImageView!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!

	// MARK: - Overrides
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setups()
	}
	
	override func prepareForReuse() {
		self.posterImageView.image = UIImage(named: "placeholder-video")
	}
	
	// MARK: - Private Methods
	
	private func setups() {
		self.setupShadowView()
		self.setupCardView()
	}
	
	private func setupShadowView() {
		self.shadowView.backgroundColor = .clear
		self.shadowView.layer.shadowOpacity = 0.5
		self.shadowView.layer.shadowRadius = 10
		self.shadowView.layer.shadowColor = UIColor.black.cgColor
		self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
	}
	
	private func setupCardView() {
		self.cardView.layer.cornerRadius = 3
	}
	
	private func setupPoster(withPath path: String) {
		let posterString: String = API.poster(photoSize: .thumb, posterPath: path)
		guard let posterURL = URL(string: posterString) else {
			return
		}
		
		let placeholder = UIImage(named: "placeholder-video")
		self.posterImageView.load(from: posterURL, withPlaceholder: placeholder)
	}

	// MARK: - Internal Methods
	
	func setup(withCellViewModel viewModel: CellViewModel) {
		self.setupPoster(withPath: viewModel.posterPath)
		self.titleLabel.text = viewModel.title
		self.releaseDateLabel.text = viewModel.releaseDate
		self.overviewLabel.text = viewModel.overview
	}
}
