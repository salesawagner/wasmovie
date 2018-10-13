//
//  UIColorExtensions.swift
//  WasMovie
//
//  Created by Wagner Sales on 13/10/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

extension UIColor {
	
	/**
	Construct a UIColor using an Int Value RGB formatted value and an alpha value
	
	- parameter r: Red Int value.
	- parameter g: Green Int value.
	- parameter b: Blue Int Value
	- parameter a: Alpha value.
	
	- returns: An UIColor instance that represent the required color
	*/
	convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
		
		let red		= CGFloat(r) / 255.0
		let green	= CGFloat(g) / 255.0
		let blue	= CGFloat(b) / 255.0
		self.init(red: red, green: green, blue: blue, alpha: CGFloat(a))
	}
	
	public func colorToUInt() -> UInt? {
		
		var intColor: UInt?
		
		var fRed : CGFloat = 0, fGreen : CGFloat = 0, fBlue : CGFloat = 0, fAlpha: CGFloat = 0
		if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
			let iRed	= UInt(fRed * 255.0)
			let iGreen	= UInt(fGreen * 255.0)
			let iBlue	= UInt(fBlue * 255.0)
			let iAlpha	= UInt(fAlpha * 255.0)
			
			intColor = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
		}
		
		return intColor
	}
	
	class func WMBlueColor() -> UIColor {
		return UIColor(r: 75, g: 95, b: 131, a: 1)
	}
	
	class func WMRedColor() -> UIColor {
		return UIColor(r: 208, g: 2, b: 27, a: 1)
	}
	
	class func WMGreenColor() -> UIColor {
		return UIColor(r: 104, g: 165, b: 38, a: 1)
	}
}
