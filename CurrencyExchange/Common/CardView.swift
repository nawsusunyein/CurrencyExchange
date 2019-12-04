//
//  CardView.swift
//  CurrencyExchange
//
//  Created by Naw Su Su Nyein on 12/5/19.
//  Copyright © 2019 Naw Su Su Nyein. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    var cornnerRadius : CGFloat = 5
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 5
    
    var shadowColour : UIColor = UIColor.gray
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
