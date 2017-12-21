//
//  CustomizableImageView.swift
//  Prept
//
//  Created by Jeremy Gaston on 9/17/17.
//  Copyright © 2017 Prept Apps, LLC. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    
}
