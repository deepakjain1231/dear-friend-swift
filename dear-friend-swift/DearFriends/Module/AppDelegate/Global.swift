//
//  Global.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 28/11/24.
//

import Foundation
import UIKit


struct GlobalConstants
{

    //Implementation View height
    static let screenHeightDeveloper : Double = 667
    static let screenWidthDeveloper : Double = 375
    
    //System width height
    static let windowWidth: Double = Double(UIScreen.main.bounds.size.width)
    static let windowHeight: Double = Double(UIScreen.main.bounds.size.height)
    
}


//MARK: - MANAGE WIDGH
func manageWidth(size : Double) -> CGFloat{
    let cal : Double = GlobalConstants.windowWidth * size
    
    return CGFloat(cal / GlobalConstants.screenWidthDeveloper)
}
