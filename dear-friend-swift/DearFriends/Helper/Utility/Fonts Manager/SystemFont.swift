//
//  CustomFont.swift
//  Hypno Tizely
//
//  Created by ZB_Mac_Mini on 22/11/21.
//

import UIKit

class SystemFont: NSObject {
    
    static let sharedInstance: SystemFont = {
        let instance = SystemFont()
        return instance
    }()
}

struct Fonts {
    static let Montserrat_Regular = UIFont(name: "Montserrat-Regular", size: dynamicFontSize(17))
}

func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.size.width
    let calculatedFontSize = screenWidth / 375 * FontSize
    return calculatedFontSize
}
