//
//  Global.swift
//  Aeshee
//
//  Created by Apple on 25/10/18.
//  Created by Jigar Khatri on 30/04/21.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import CloudKit

let GradientBGColors = [UIColor.init(hex: "0F143A"), UIColor.init(hex: "251B62")]
let About_GradientBGColors = [UIColor.init(hex: "0E064A").withAlphaComponent(0), UIColor.init(hex: "0E064A").withAlphaComponent(1)]
var dic_aboutCreator = OnboardingAboutCreatorModel(object: nil)

let ANI_RIPPLE_ALPHA: CGFloat = 0.5
let ANI_RIPPLE_SCALE: CGFloat = 1.6
public var aniRippleColor: UIColor!
public var aniRippleScale: CGFloat = 0.0
public var aniGoOutDuration: TimeInterval = 0.0

let showcase_1_indx_0_Title = "Content Progress Bar"
let showcase_1_indx_0_subTitle = "See your progress at a glance with the Content Progress Bar. A purple line shows how far you’ve listened, while a white check mark and subtle gray line appear when the content is complete. This gentle guide helps you easily continue where you left off, and also encourages you to revisit your favorites anytime you want."

let showcase_1_indx_1_Title = "Download, Favorite, or Pin"
let showcase_1_indx_1_subTitle = "Download, favorite, or pin meditations to easily access them anytime."

let showcase_2_indx_0_Title = "Feedback & Share"
let showcase_2_indx_0_subTitle = "Share your thoughts or recommend this meditation to a friend."

let showcase_2_indx_1_Title = "Background Audio Selection"
let showcase_2_indx_1_subTitle = "Choose the perfect background sound to enhance your experience."

//MARK: - Vimeo Access
var BaseURL_Vimeo = "https://api.vimeo.com/videos/"
var Kvimeo_access_Token = "Bearer f175f11de1fe5d8a06f9fda1143a3a77"

var MIXPANEL_TOKEN = "a25acd8983c79ef15a967f4598d99037"// "9e517e56632fb5f4da649a6141c7dbe0"


struct GlobalConstants
{
    // Constant define here.
    static let developerTest : Bool = false
    static let appLive : Bool = true
    
    //Implementation View height
    static let screenHeightDeveloper : Double =  checkDeviceiPad() ? 1024 : 926
    static let screenWidthDeveloper : Double = checkDeviceiPad() ? 768 : 393


    //Name And Appdelegate Object
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)

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
    static let OUTFIT_FONT_Bold = "Outfit-Bold"

    static let appStoreId = "6477375969"

}
let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft

//GET VIEW TOP
var getTopViewController: UIViewController? {
    
    guard let rootViewController = GlobalConstants.appDelegate?.window?.rootViewController else {
        return nil
    }
    
    return getVisibleViewController(rootViewController)
}


func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
    
    if let presentedViewController = rootViewController.presentedViewController {
        return getVisibleViewController(presentedViewController)
    }
    
    if let navigationController = rootViewController as? UINavigationController {
        return navigationController.visibleViewController
    }
    
    if let tabBarController = rootViewController as? UITabBarController {
        return tabBarController.selectedViewController
    }
    
    return rootViewController
}


//............................... ALERT MESSAGE ...............................................//
func showAlertMessage(strMessage: String) {

    let alert = UIAlertController(title: "Dear Friend", message: strMessage, preferredStyle: UIAlertController.Style.alert)

    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    getTopViewController?.present(alert, animated: true, completion: nil)

    //    //POPUP
    //    let window = UIApplication.shared.keyWindow!
    //    window.endEditing(true)
    //    let aleartView = AlertMessage(frame: CGRect(x: 0, y: 0 ,width : window.frame.width, height: window.frame.height))
    //    aleartView.loadPopUpView(strMessage: strMessage)
    //    window.addSubview(aleartView)
        
}


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

//MARK: - SET KEYBOARD
@MainActor func setupKeyboard(_ enable: Bool) {
    IQKeyboardManager.shared.enable = enable
    IQKeyboardManager.shared.enableAutoToolbar = enable
    IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = !enable
    IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysShow
}

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



//GET VIEW TOP
extension UIApplication {
    class func getTopViewController(base: UIViewController? = GlobalConstants.appDelegate?.window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        else  if let tabbar = base?.children.first(where: {$0 is RootStackTabViewController}) as? RootStackTabViewController {
            return getTopViewController(base: tabbar)
        }
        else  if let tabbar = base?.children.first as? UINavigationController {
            return getTopViewController(base: tabbar)
        }
        return base
    }
    
    public var mainKeyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap { $0 as? UIWindowScene }?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}


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
