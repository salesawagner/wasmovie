//
//  PlaceholderView.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    
    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    // MARK: - Private Methods
    
    private func loadNib() {
        Bundle.main.loadNibNamed(String(describing: PlaceholderView.self),
                                 owner: self,
                                 options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.frame
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
	
	// MARK: - Internal Methods
    
    func setupUI(with viewModel: PlaceholderViewModel) {
        self.imageView.image = viewModel.image
        self.imageView.isHidden = viewModel.image == nil
        self.titleLabel.text = viewModel.title
        self.messageLabel.text = viewModel.message
    }
}
