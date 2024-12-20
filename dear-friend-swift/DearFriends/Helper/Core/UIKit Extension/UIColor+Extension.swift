//
//  UIColor+Extension.swift
//  Deonde
//
//  Created by Ankit Rupapara on 21/04/20.
//  Copyright © 2020 Ankit Rupapara. All rights reserved.
//

import UIKit


//Never user Color enum directly, use UIColor's Extenion's property only
enum Color {
    static let primary = UIColor(named: "primary")
    static let secondary = UIColor(named: "secondary")
    static let background = UIColor(named: "background")
    
    static let secondary_dark = UIColor(named: "secondary_dark")
    static let secondary_light = UIColor(named: "secondary_light")
    
    static let text_color_light = UIColor(named: "Text_color")

    static let buttonBGColor = UIColor(named: "buttonBGColor")

}

extension UIColor{
    static let primary = Color.primary
    static let secondary = Color.secondary
    static let background = Color.background
    
    
    static let secondary_dark = Color.secondary_dark
    static let secondary_light = Color.secondary_light
    static let text_color_light = Color.text_color_light
    static let buttonBGColor = Color.buttonBGColor

}
