//
//  Global.swift
//  Aeshee
//
//  Created by Apple on 25/10/18.
//  Created by Jigar Khatri on 30/04/21.
//

import Foundation
import UIKit

let GradientBGColors = [UIColor.init(hex: "0F143A"), UIColor.init(hex: "251B62")]

struct GlobalConstants
{
    // Constant define here.
    static let developerTest : Bool = false
    static let appLive : Bool = true
    
    //Implementation View height
    static let screenHeightDeveloper : Double =  checkDeviceiPad() ? 1024 : 926
    static let screenWidthDeveloper : Double = checkDeviceiPad() ? 768 : 393


     
    //System width height
    static let windowWidth: Double = checkLandscape() ? Double(UIScreen.main.bounds.size.height) : Double(UIScreen.main.bounds.size.width)
    static let windowHeight: Double = checkLandscape() ? Double(UIScreen.main.bounds.size.width) : Double(UIScreen.main.bounds.size.height)

//    static let windowHeight: Double = Double(UIScreen.main.bounds.size.height)
    
   
    //FONT NAME
    static let PLAY_FONT_Bold = "Play-Bold"
    static let PLAY_FONT_Regular = "Play-Regular"
    
    static let RAMBLA_FONT_Bold = "Rambla-Bold"
    static let RAMBLA_FONT_Regular = "Rambla-Regular"
    static let OUTFIT_FONT_Regular = "Outfit-Regular"
    static let OUTFIT_FONT_Medium = "Outfit-Medium"
    static let OUTFIT_FONT_SemiBold = "Outfit-SemiBold"

    static let appStoreId = "6477375969"

}
let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft




//............................... MANAGE ...............................................//

//MARK: - MANAGE FONT

func CheckFontNameList (){
    //CHECK FONT NAME
    for fontFamilyName in UIFont.familyNames{
        for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
            print("Family: \(fontFamilyName)     Font: \(fontName)")
        }
    }
}

func checkDeviceiPad() -> Bool{
    return UIDevice.current.userInterfaceIdiom == .pad ? true : false
}
func checkLandscape() -> Bool{
    if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
        return true
    } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
        return true
    } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
        return false
    } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
        return false
    }
    else if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
        return true
    }
    return false
}

func manageFont(font : Double) -> CGFloat{
    var screenSize = Double(UIScreen.main.bounds.size.width)
    if checkLandscape(){
        screenSize = Double(UIScreen.main.bounds.size.height)
    }
    let cal : Double = screenSize * font
    return CGFloat(cal / GlobalConstants.screenWidthDeveloper)
}

//MARK: - MANAGE HEIGHT
func manageHeight(size : Double) -> CGFloat{
    var screenSize = Double(UIScreen.main.bounds.size.width)
    if checkLandscape(){
        screenSize = Double(UIScreen.main.bounds.size.height)
    }
    let cal : Double = screenSize * size
    return CGFloat(cal / GlobalConstants.screenHeightDeveloper)
}

//MARK: - MANAGE WIDGH
func manageWidth(size : Double) -> CGFloat{
    var screenSize = Double(UIScreen.main.bounds.size.width)
    if checkLandscape(){
        screenSize = Double(UIScreen.main.bounds.size.height)
    }
    let cal : Double = screenSize * size
    return CGFloat(cal / GlobalConstants.screenWidthDeveloper)
}

//MAKE
// For Swift 5
func delay(_ delay:Double, closure:@escaping ()->()) {
 let when = DispatchTime.now() + delay
 DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

 // For Swift 5
func main_thread(closure:@escaping ()->()) {
  //    DispatchQueue.global(qos: .background).async {
 let when = DispatchTime.now()
 DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  //    }
}

//class customSliderProgress: UISlider {
//    override func draw(_ rect: CGRect) {
//        self.setMinimumTrackImage(UIImage.fromColor(color: UIColor.primary , in: 5), for: .normal)
//        self.setMaximumTrackImage(UIImage.fromColor(color: UIColor.customWhite.withAlphaComponent(0.3) , in: 5), for: .normal)
////        self.setMinimumTrackImage(UIImage.fromColor(color: #colorLiteral(red: 0.6588235294, green: 0.9960784314, blue: 0.1882352941, alpha: 1), in: 5), for: .normal)
////        self.setMaximumTrackImage(UIImage.fromColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2984693878), in: 5), for: .normal)
////        self.setThumbImage(#imageLiteral(resourceName: "icon_progress"), for: .normal)
//        self.setThumbImage(UIImage(), for: .normal)
//
//    }
//}

//............................... SET COLOR ...............................................//

// MARK: - SET COLOR
func colorFromRGB(valueRed: CGFloat, valueGreen: CGFloat, valueBlue: CGFloat) -> UIColor {
    return UIColor(red: valueRed / 255.0, green: valueGreen / 255.0, blue: valueBlue / 255.0, alpha: 1.0)
    
}

//SET IMAGE COLOR
func imgColor (imgColor : UIImageView ,  colorHex : UIColor?){
    let templateImage = imgColor.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    imgColor.image = templateImage
    imgColor.tintColor = colorHex
}


func buttonImageColor (btnImage : UIButton, imageName : String , colorHex: UIColor?){
    let buttonImage = UIImage(named: imageName)
    btnImage.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    btnImage.tintColor = colorHex
}


//............................... SET THE FONT ...............................................//

func SetTheFont(fontName :String, size :Double) -> UIFont {
    return UIFont(name: fontName, size: manageFont(font: size))!
}



extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}

//func showAlertErrorMessage(strMessage: String) {
//
//    let alert = UIAlertController(title: str.error, message: strMessage, preferredStyle: UIAlertController.Style.alert)
//    if #available(iOS 13.0, *) {
//        alert.overrideUserInterfaceStyle = .dark
//    } else {
//        // Fallback on earlier versions
//    }
//    alert.view.tintColor = UIColor.primary
//    alert.addAction(UIAlertAction(title: str.ok, style: UIAlertAction.Style.default, handler: nil))
//    getTopViewController?.present(alert, animated: true, completion: nil)
//}



public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
