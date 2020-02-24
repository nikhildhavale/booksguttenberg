//
//  Extensions.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var HeadingFont1:UIFont
    {
        return UIFont(name: FontConstant.MonserratSemiBold, size: 48)!
    }
    static var HeadingFont2:UIFont
    {
        return UIFont(name: FontConstant.MonserratSemiBold, size: 30)!
        
    }
    static var GenreCard:UIFont
    {
        return UIFont(name: FontConstant.Monserrat, size: 20)!
        
    }
    static var Body:UIFont
    {
        return UIFont(name: FontConstant.Monserrat, size: 16)!
        
    }
    static var SearchBox:UIFont
    {
        return UIFont(name: FontConstant.Monserrat, size: 16)!
        
    }
    static var BookName:UIFont
    {
        return UIFont(name: FontConstant.Monserrat, size: 12)!
        
    }
    static var BookAuthor:UIFont
    {
        return UIFont(name: FontConstant.Monserrat, size: 12)!
        
    }
    
}
extension UILabel
{
    func setHeading1Font()
    {
        self.font = UIFont.HeadingFont1
    }
}
extension UISearchBar
{
    func setup()
    {
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: StringsConstant.search, attributes: [NSAttributedString.Key.font:UIFont.SearchBox,NSAttributedString.Key.foregroundColor:ColorConstant.darkgrey])
        self.searchTextField.textColor = ColorConstant.darkergrey
        
    }
    
}
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
            
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
            
        }
    }
}
extension String {
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }

}
