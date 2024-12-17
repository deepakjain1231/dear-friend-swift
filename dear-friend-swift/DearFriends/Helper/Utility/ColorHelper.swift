//
//  ColorHelper.swift
//  Estalim
//
//  Created by Mac on 04/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
extension UIColor{
    //Colors are computed class properties. To refrence the class, use self
    
    class var SubmitButtonBGColor:UIColor {
        return self.init(red: 18.0/255, green: 21.0/255, blue: 18.0/255, alpha: 1.0)
    }
    class var TextFieldColor:UIColor {
        return self.init(red: 244.0/255, green: 244.0/255, blue: 244.0/255, alpha: 1.0)
    }
    
    static let appGreenColor : UIColor = hexStringToUIColor(hex: "#638C1C")
    static let appGreenColor2 : UIColor = hexStringToUIColor(hex: "#776ADA")
    static var AppDefaultColor: UIColor = hexStringToUIColor(hex: "#776ADA")
    static var AppDefaultColor2: UIColor = hexStringToUIColor(hex: "#776ADA")
    
    class var AppDefaultDarkColor:UIColor {
        return self.init(red: 0.0/255, green: 181.0/255, blue: 192.0/255, alpha: 1.0)
    }
    class var NavigationColor:UIColor {
        return self.init(red: 18.0/255, green: 21.0/255, blue: 18.0/255, alpha: 1.0)
    }
    class var CommonBG:UIColor {
        return self.init(red: 253/255, green: 251/255, blue: 248/255, alpha: 1.0)
    }
    
    //The hexColor method is a class method taking a UInt32 and alpha value and returns a color. See http://bit.ly/HexColorsWeb onhow it works.
    
    class func hexColor(_ hexColorNumber:UInt32, alpha: CGFloat) -> UIColor {
        let red = (hexColorNumber & 0xff0000) >> 16
        let green = (hexColorNumber & 0x00ff00) >> 8
        let blue =  (hexColorNumber & 0x0000ff)
        return self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor], isHori: Bool = true) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        if isHori {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
