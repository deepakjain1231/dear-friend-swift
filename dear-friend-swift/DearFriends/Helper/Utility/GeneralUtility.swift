//
//  GeneralUtility.swift
//  SurveyPlatform
//
//  Created by Devubha Manek on 12/11/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import Foundation
import ExpandableLabel
import AVFoundation
import NVActivityIndicatorView
import MobileCoreServices
import SDWebImage
import Haptico
import CoreLocation

typealias anyActionAlias = ((_ sender : Any) -> Void)
typealias buttonActionAlias = ((_ sender: UIButton) -> Void)
typealias controlActionAlias = ((_ sender: UIControl) -> Void)
typealias voidCloser = (() -> Void)
typealias intCloser = ((Int) -> Void)
typealias stringCloser = ((String) -> Void)
typealias DoubeStringCloser = ((String, String) -> Void)
typealias BoolToVoidCloser = ((Bool) -> Void)
typealias audioModel = ((AudioViewModel) -> Void)
typealias reloadMainCate = (([SubCategory]) -> Void)

let profilePlaceholder : UIImage? = UIImage(named: "")

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    @available(iOS 13.0, *)
    case soft
    @available(iOS 13.0, *)
    case rigid
    case selection
    case oldSchool
    
    public func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += RightPadding
        return textRect
    }
    
    @IBInspectable var RightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var RightPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = RightImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}

class CustomDashedView: UIView {
    
    @IBInspectable var cornerRadiusForDashhed: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

extension UIDevice {
    var hasNotch: Bool {
        
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
            
        } else {
            return false
        }
    }
}

var hasSmallDevice: Bool {
    return UIScreen.main.bounds.height <= 667.0
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
extension UITextField {
    
    func setRightView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate =  Date()
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

class GeneralUtility: NSObject {
    
    //MARK: - Shared Instance
    static let sharedInstance : GeneralUtility = {
        let instance = GeneralUtility()
        return instance
    }()
    func getCommonHeaderHeight() -> CGFloat {
        if UIDevice.current.hasNotch {
            return 140
        }
        return 114
    }
    
    func convertToDateFromString(olddate: Date, format: String = "yyyy-MM-dd", withUTC: Bool = false) -> String {
        let date = olddate
        let dateFormatter = DateFormatter()
        if withUTC {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    func changeTextColor(substring: String,
                         string: String,
                         foregroundColor: UIColor,
                         label: UILabel) {
        
        let fullString = string
        
        // Create attributed string with default attributes
        let attributedString = NSMutableAttributedString(string: fullString)
        
        // Create a font attribute for the specific text
        let boldFontAttribute = [NSAttributedString.Key.foregroundColor: foregroundColor, NSAttributedString.Key.font: Font(.installed(.Regular), size: .standard(.S16)).instance]
        
        // Apply the font attribute to the desired range of the string
        let searchString = substring
        let range = (attributedString.string as NSString).range(of: searchString)
        
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        // Assign the attributed string to the label
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
    }
    
    func getAppGradientClr(viewFrame: CGRect, isHori: Bool = true) -> UIColor {
        let gradientImage = UIImage.gradientImageWithBounds(bounds: viewFrame, colors: [#colorLiteral(red: 0.07450980392, green: 0.6941176471, blue: 0.06274509804, alpha: 1).cgColor, #colorLiteral(red: 0.03529411765, green: 0.5019607843, blue: 0.02745098039, alpha: 1).cgColor], isHori: isHori)
        return UIColor.init(patternImage: gradientImage)
    }
    
    func getAnyGradientClr(clr1: UIColor, clr2: UIColor, viewFrame: CGRect, isHori: Bool = true) -> UIColor {
        let gradientImage = UIImage.gradientImageWithBounds(bounds: viewFrame, colors: [clr1.cgColor, clr2.cgColor], isHori: isHori)
        return UIColor.init(patternImage: gradientImage)
    }
    
    func getAppGradientImage(viewFrame: CGRect) -> UIImage {
        let gradientImage = UIImage.gradientImageWithBounds(bounds: viewFrame, colors: [#colorLiteral(red: 0.07450980392, green: 0.6941176471, blue: 0.06274509804, alpha: 1).cgColor, #colorLiteral(red: 0.03529411765, green: 0.5019607843, blue: 0.02745098039, alpha: 1).cgColor])
        return gradientImage
    }
    
    func convertTwoDecimalFlot(value: Double) -> String {
        return "\(String(format: "%.2f", value))"
    }
    
    func getCommonHeaderHeightWithuotCornerRadius() -> CGFloat {
        if UIDevice.current.hasNotch {
            return 110
        }
        return 80
    }
    
    func animateTableview(tableview: UITableView, subtype : CATransitionSubtype? ) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = subtype
        tableview.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        tableview.reloadData()
    }
    
    func addButtonTapHaptic() {
        Haptico.shared().generate(.light)
    }
    
    func addErrorHaptic() {
        Haptico.shared().generate(.error)
    }
    
    func addSuccessHaptic() {
        Haptico.shared().generate(.success)
    }
    
    func addWarningHaptic() {
        Haptico.shared().generate(.warning)
    }
    
    class func createActivityIndi() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        spinner.color = .black
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    func setImage(imgView: UIImageView?,
                  placeHolderImage: UIImage? = placeholderImage,
                  imgPath: String,
                  isShowLoader: Bool = true,
                  isWithoutFade: Bool = false) {
        
        let imageNew = imgPath
        if let _ = URL(string: imageNew), let imgView = imgView {
            //DispatchQueue.main.async {

                RemoteImageCacheLoader.shared.loadImage(from: imgPath, into: imgView, placeholder: nil)
                
                
                
//                var thumbnailSize = imgView.frame.size
//                thumbnailSize.width *= UIScreen.main.scale
//                thumbnailSize.height *= UIScreen.main.scale
//                SDImageCoderHelper.defaultScaleDownLimitBytes = UInt(imgView.frame.size.width * imgView.frame.size.height * 4)
//                let optins: SDWebImageOptions = [.refreshCached]
//                imgView.sd_imageTransition = .fade
//                imgView.sd_imageIndicator = SDWebImageActivityIndicator.white
//                imgView.sd_setImage(with: URL(string: imgPath), placeholderImage: nil, options: optins, context: [.imageThumbnailPixelSize : thumbnailSize])
            //}
            
        } else {
            DispatchQueue.main.async {
                imgView?.sd_imageTransition = .none
                imgView?.image = placeHolderImage
            }
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    //MARK:- ERROR MESSAGE
    
    func showErrorMessage(message: String) {
        
        self.addErrorHaptic()
        let toast = Toast.text(message, isForError: true)
        toast.show()
//
//        var viewcontroller = UIApplication.topViewController()
//        if ((viewcontroller as? LoadingDailog) != nil) {
//            viewcontroller = UIApplication.topViewController()?.presentingViewController
//        }
//        showAlertWithTitleFromVC(vc: viewcontroller!, andMessage: message.localized)
    }
    
    func showSuccessMessage(message: String) {
        
        self.addSuccessHaptic()
        
//        var viewcontroller = UIApplication.topViewController()
//        if ((viewcontroller as? LoadingDailog) != nil) {
//            viewcontroller = UIApplication.topViewController()?.presentingViewController
//        }
//        showAlertWithTitleFromVC(vc: viewcontroller!, andMessage: message.localized)
        
        let toast = Toast.text(message, isForError: false)
        toast.show()
    }
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
                print("path : \(dbPath)")
            } catch let error1 as NSError {
                error = error1
            }
        }
    }
}

func setView(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
    })
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

//MARK: - Font Layout
struct FontName {
    //Font Name List
    static let MetropolisBoldItalic = "Metropolis-BoldItalic"
    static let MetropolisLight = "Metropolis-Light"
    static let MetropolisUltraLightItalic = "Metropolis-UltraLightItalic"
    static let MetropolisCondensedBold = "Metropolis-CondensedBold"
    static let MetropolisMediumItalic = "Metropolis-MediumItalic"
    static let MetropolisThin = "Metropolis-Thin"
    static let MetropolisMedium = "Metropolis-Medium"
    static let MetropolisThinItalic = "Metropolis-ThinItalic"
    static let MetropolisLightItalic = "Metropolis-LightItalic"
    static let MetropolisUltraLight = "Metropolis-UltraLight"
    static let MetropolisBold = "Metropolis-Bold"
    static let MetropolisExtraBold = "Metropolis-ExtraBold"
    static let MetropolisSemidBold = "Metropolis-SemiBold"
    static let Metropolis = "Metropolis"
    static let MetropolisCondensedBlack = "Metropolis-CondensedBlack"
    static let RobotoRegular = "Roboto-Regular"
    static let RobotoLight = "Roboto-Light"
}

// MARK: - Hex to UIcolor
func hexStringToUIColor (hex:String) -> UIColor {
    
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController2(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController2(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController2(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController2(viewController: presented)
        }
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(viewController: slide.mainViewController)
        //        }
        return viewController
    }
}

extension UIColor{
    class func AppBlue() -> UIColor {
        return UIColor.init(red: 80.0/255.0, green: 153.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    class func AppYellow() -> UIColor {
        return UIColor.init(red: 245.0/255.0, green: 117.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    class func AppRed() -> UIColor {
        return UIColor.init(red: 206/255.0, green: 236/255.0, blue: 154/255.0, alpha: 0.25)
    }
    class func AppGreen() -> UIColor {
        return UIColor.init(red: 19.0/255.0, green: 197.0/255.0, blue: 111.0/255.0, alpha: 1.0)
    }
}

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
extension UIBezierPath {
    
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != 0 {
            path.move(to: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }
        
        if topRightRadius != 0 {
            path.addLine(to: CGPoint(x: topRight.x - topRightRadius, y: topRight.y))
            path.addArc(tangent1End: topRight, tangent2End: CGPoint(x: topRight.x, y: topRight.y + topRightRadius), radius: topRightRadius)
        }
        else {
            path.addLine(to: topRight)
        }
        
        if bottomRightRadius != 0 {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius))
            path.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bottomRight.x - bottomRightRadius, y: bottomRight.y), radius: bottomRightRadius)
        }
        else {
            path.addLine(to: bottomRight)
        }
        
        if bottomLeftRadius != 0 {
            path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y))
            path.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius), radius: bottomLeftRadius)
        }
        else {
            path.addLine(to: bottomLeft)
        }
        
        if topLeftRadius != 0 {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius))
            path.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y), radius: topLeftRadius)
        }
        else {
            path.addLine(to: topLeft)
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension UIImageView {
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}

@IBDesignable
open class VariableCornerRadiusView: UIView  {
    
    private func applyRadiusMaskFor() {
        let path = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        //layer.mask = shape
        self.layer.insertSublayer(shape, at: 0)
        //shape.backgroundColor = UIColor.white.cgColor
        //layer.addSublayer(shape)
        
        //self.addShadow()
        
    }
    
    @IBInspectable
    open var topLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var topRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var bottomLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var bottomRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        applyRadiusMaskFor()
        //add_shadow(demoView: self, height: 2)
    }
}

extension UIView {
    
    //MARK: - IBInspectable
   
    @IBInspectable var BottomCorner: Bool {
        get {
            return layer.cornerRadius > 0.0
        }
        set {
            if newValue == true {
                self.clipsToBounds = true
                self.layer.cornerRadius = 20
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
    }

    @IBInspectable var TopCorner: Bool {
        get {
            return layer.cornerRadius > 0.0
        }
        set {
            if newValue == true {
                self.clipsToBounds = true
                self.layer.cornerRadius = 35
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    @IBInspectable var CommonShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall(shadowColor: hexStringToUIColor(hex: "D3D1D840").cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.2, shadowRadius: 4)
            }
        }
    }
    
    @IBInspectable var CommonShadow2: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.2, shadowRadius: 4)
            }
        }
    }
    
    @IBInspectable var Black: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: 0, height: 1), shadowOpacity: 0.2, shadowRadius: 4)
            }
        }
    }
    
    @IBInspectable var SuperBlack: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.2, shadowRadius: 6)
            }
        }
    }
    
    @IBInspectable var TopSuperBlack: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor, shadowOffset: CGSize(width: 0, height: -26), shadowOpacity: 1, shadowRadius: 85)
            }
        }
    }
    
//    @IBInspectable var GradientBorder: Bool {
//        get {
//            return layer.shadowOpacity > 0.0
//        }
//        set {
//            if newValue == true {
//                self.addBorderNew()
//            }
//        }
//    }
    
    func addBorderNew() {
                
        self.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors =  [hexStringToUIColor(hex: "#B05148").cgColor,
                            hexStringToUIColor(hex: "#F29A56").cgColor,
                            hexStringToUIColor(hex: "#FFE1AC").cgColor,
                            hexStringToUIColor(hex: "#8D3B33").cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = 4

        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath

        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = CGSize(width: 0, height: 20)
        gradient.shadowOpacity = 1
        gradient.shadowRadius = 85
        
        self.layer.addSublayer(gradient)
    }
    
//    @IBInspectable var WhiteGradientBorder: Bool {
//        get {
//            return layer.shadowOpacity > 0.0
//        }
//        set {
//            if newValue == true {
//                self.addBorderNew3()
//            }
//        }
//    }
    
    func addBorderNew3() {
                
        self.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors =  [hexStringToUIColor(hex: "#FFFFFF").withAlphaComponent(0.2).cgColor,
                            hexStringToUIColor(hex: "#FFFFFF").withAlphaComponent(0).cgColor,
                            hexStringToUIColor(hex: "#FFFFFF").withAlphaComponent(0.2).cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = 2

        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath

        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowOffset = CGSize(width: 0, height: 20)
        gradient.shadowOpacity = 1
        gradient.shadowRadius = 85
        gradient.cornerRadius = 8
        gradient.masksToBounds = true

        self.layer.insertSublayer(gradient, at: 0)
    }

    func addBGGradient() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0).cgColor,
                                UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0.59).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = self.cornerRadius
        gradientLayer.masksToBounds = true
        
        // Add the gradient layer to the view's layer
        
        self.clipsToBounds = true
        self.layer.addSublayer(gradientLayer)
    }
    
    //shadow changes =
    @IBInspectable var shadowForTextFields: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.clipsToBounds = false
                //layer.cornerRadius = 17.0
                layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
                layer.shadowOpacity = 1
                layer.shadowRadius = 10
                layer.shadowOffset = CGSize(width: 0, height: 3)
            }
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    func addShadowSmall(shadowColor: CGColor = UIColor.black.cgColor,
                        shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                        shadowOpacity: Float = 0.2,
                        shadowRadius: CGFloat = 2.0) {
        
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    /// to add round corner and autoupdate when the view's frame change
    ///
    /// - Parameter corners:
    /// for topLeft - layerMinXMinYCorner,
    /// for topRight - layerMaxXMinYCorner,
    /// for bottomLeft - layerMinXMaxYCorner,
    /// for bottomRight - layerMaxXMaxYCorner,
    ///
    func roundCornersWithMask(corners:CACornerMask, radius: CGFloat) {
        //self.clipsToBounds = false
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    
    func shadowWithMaskedCorner(corners:CACornerMask, radius: CGFloat,
                                shadowColor: CGColor = UIColor.black.cgColor,
                                shadowOffset: CGSize = CGSize.zero,
                                shadowOpacity: Float = 0.5,
                                shadowRadius: CGFloat = 2.8) {
        //self.clipsToBounds = false
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func roundCornersWithShadow(corners:UIRectCorner, radius: CGFloat) {
        
        var shadowLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        shadowLayer.path = path.cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 2
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    //Set Shadow in View
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.1, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.1, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
}

@IBDesignable class GradientView: UILabel {
    
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0.07450980392, green: 0.6941176471, blue: 0.06274509804, alpha: 1)
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.03529411765, green: 0.5019607843, blue: 0.02745098039, alpha: 1)
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.5)
        return layer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        //updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
}

class BackGroundView: UIView {
    
    //@IBInspectable var firstColor: UIColor = UIColor.CellBackground
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.AppDefaultColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.AppDefaultColor
    }
    
    
}
var isIphoneXOrLonger: Bool {
    // 812.0 / 375.0 on iPhone X, XS.
    // 896.0 / 414.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 896.0 / 414.0
}

struct MyUserDefaults {
    static let UserData = "Userdata"
    static let Filter = "Filter"
}

//MARK: - Get/Set UserDefaults
func setMyUserDefaults(value:Any, key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getMyUserDefaults(key:String)->Any {
    return UserDefaults.standard.value(forKey: key) ?? ""
}

@IBDesignable class BigSwitch: UISwitch {
    
    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}

class Slider: UISlider {
    
    @IBInspectable var thumbImage: UIImage?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var SliderScale : CGFloat = 1 {
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: SliderScale, y: SliderScale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}
extension UIViewController {
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
    
    func setShadow(obj:Any, cornurRadius:CGFloat, ClipToBound:Bool, masksToBounds:Bool, shadowColor:String, shadowOpacity:Float, shadowOffset:CGSize, shadowRadius:CGFloat, shouldRasterize:Bool, shadowPath:CGRect) {
        if obj is UIView {
            let tempView:UIView = obj as! UIView
            tempView.clipsToBounds = ClipToBound
            tempView.layer.cornerRadius = cornurRadius
            tempView.layer.shadowOffset = shadowOffset
            tempView.layer.shadowOpacity = shadowOpacity
            tempView.layer.shadowRadius = shadowRadius
            tempView.layer.shadowColor = UIColor.lightGray.cgColor
            tempView.layer.masksToBounds =  masksToBounds
            tempView.layer.shouldRasterize = shouldRasterize
            tempView.layer.rasterizationScale = UIScreen.main.scale
            tempView.layer.shadowPath = UIBezierPath(roundedRect: tempView.bounds, cornerRadius: cornurRadius).cgPath
        }
    }
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    self.alpha = 0
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    self.alpha = 1
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat, CornerRadius:CGFloat)    {
        
        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)
            
            
        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)
            
            
        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }
        
        self.layer.cornerRadius = CornerRadius
        self.layer.masksToBounds = true;
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}

@IBDesignable
class DashedLineView : UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = width
            
        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = height
        }
        
        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }
    
    private var width : CGFloat {
        return self.bounds.width
    }
    
    private var height : CGFloat {
        return self.bounds.height
    }
}

struct Constant {
    
    //----------------------------------------------------------------
    //MARK:- KEY CONST -
    static let kStaticRadioOfCornerRadios:CGFloat = 0
    static let ALERT_OK                = "OK"
    static let ALERT_DISMISS           = "Dismiss"
    static let KEY_IS_USER_LOGGED_IN   = "USER_LOGGED_IN"
    static let userPic = UIImage(named: "ic_profileplaceholder")
    static let CurrencySymbol = "$"
    static let CurrencyName = "USD"
    static var APP_NAME: String = Bundle.main.displayName ?? ""
    static var BANNERAD: String = "ca-app-pub-3940256099942544/2435281174"
    static var INTERAD: String = "ca-app-pub-3940256099942544/4411468910"
}

extension TimeInterval {
    
    func stringFromTimeInterval(withString: Bool = false, isNewLine: Bool = false) -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            if isNewLine {
                return "\(hours)\nhrs"
            }
            return "\(hours) hrs"
        }
        
        if minutes > 0 {
            if isNewLine {
                return "\(minutes)\nmins"
            }
            return "\(minutes) mins"
        }
        
        if seconds > 0 {
            if isNewLine {
                return "\(seconds)\nsecs"
            }
            return "\(seconds) secs"
        }
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, ms)
    }
    
    func addSecsIntoCurrentTime() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time * 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        var date = Date()
        let calendar = Calendar.current
        
        if hours > 0 {
            date = calendar.date(byAdding: .hour, value: hours, to: Date())!
            
        } else if minutes > 0 {
            date = calendar.date(byAdding: .minute, value: minutes, to: Date())!
            
        } else if seconds > 0 {
            date = calendar.date(byAdding: .second, value: seconds, to: Date())!
        }
        
        print("minutes Response:", minutes)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}

extension Bundle {
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}

extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}

extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

extension UIImage {
    
    static let names: [String] = ["argentina", "bolivia", "brazil", "chile", "costa rica", "cuba", "dominican republic", "ecuador", "el salvador", "haiti", "honduras", "mexico", "nicaragua", "panama", "paraguay", "peru", "venezuela"]
    
}

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

enum AppStoryboard: String {
    
    case main = "Main"
    case Tabbar = "Tabbar"
    case Home = "Home"
    case Explore = "Explore"
    case Profile = "Profile"
    case MyBookings = "MyBookings"
    case Yoga = "Yoga"
    case CreateMusic = "CreateMusic"
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {
        
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T ?? T()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        } else {
            @objc class ClosureSleeve: NSObject {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: "kCATransitionPush")
    }
    
    func downTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.duration = duration
        layer.add(animation, forKey: "kCATransitionDown")
    }
}

enum Notifications: String {
    
    case reloadOrderDetails = "reloadOrderDetails"
    case reloadOrderList = "reloadOrderList"
    case reloadNotificationList = "reloadNotificationList"
    case reloadHOME = "reloadHOME"
    case reloadTrackOrder = "reloadTrackOrder"
}

extension CLLocationCoordinate2D {
    
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
        
        let fromLatitude = degreesToRadians(latitude)
        let fromLongitude = degreesToRadians(longitude)
        
        let toLatitude = degreesToRadians(point.latitude)
        let toLongitude = degreesToRadians(point.longitude)
        
        let differenceLongitude = toLongitude - fromLongitude
        
        let y = sin(differenceLongitude) * cos(toLatitude)
        let x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(differenceLongitude)
        let radiansBearing = atan2(y, x);
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }
}

@IBDesignable
class LineSpacingLBL: UILabel {

    @IBInspectable var LineSpacing: CGFloat = 0.0 {
        didSet {
            self.setLineSpacing(lineSpacing: LineSpacing)
        }
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

extension UIViewController {

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.5) {
        if self.tabBarController?.tabBar.isHidden != hidden{
            if animated {
                //Show the tabbar before the animation in case it has to appear
                if (self.tabBarController?.tabBar.isHidden)!{
                    self.tabBarController?.tabBar.isHidden = hidden
                }
                if let frame = self.tabBarController?.tabBar.frame {
                    let factor: CGFloat = hidden ? 1 : -1
                    let y = frame.origin.y + (frame.size.height * factor)
                    UIView.animate(withDuration: duration, animations: {
                        self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                    }) { (bool) in
                        //hide the tabbar after the animation in case ti has to be hidden
                        if (!(self.tabBarController?.tabBar.isHidden)!){
                            self.tabBarController?.tabBar.isHidden = hidden
                            self.tabBarController?.tabBar.backgroundColor = hidden == true ? .clear : .white
                        }
                    }
                }
            }
        }
    }
}

class GradientLabel: UILabel {
    var gradientColors: [CGColor] = [hexStringToUIColor(hex: "#F29A56").cgColor,
                                     hexStringToUIColor(hex: "#FFE1AC").cgColor]

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}

func getStrDateFromStrDate(date: String, fromFormate: String = "yyyy-MM-dd HH:mm:ss", toFormDate: String = "yyyy-MM-dd HH:mm:ss") -> String {
    
    if date == "" {
        return date
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormate
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let dt = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = toFormDate
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let date = dateFormatter.string(from: dt!)
    
    return date
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

class AppExpandableLabel: ExpandableLabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupLabel() {
        let attributesOf : [NSAttributedString.Key : Any] = [.foregroundColor : hexStringToUIColor(hex: "#7884E0")]
        self.collapsedAttributedLink = NSAttributedString(string: "Read More", attributes: attributesOf)
        self.expandedAttributedLink = NSAttributedString(string: "Read Less", attributes: attributesOf)

        self.shouldCollapse = true
        self.textReplacementType = .word
        self.numberOfLines = 2
//        self.collapsed = true
    }
}



import UIKit

class RemoteImageCacheLoader {
    static let shared = RemoteImageCacheLoader()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    /// Loads image using only memory cache → downloads if not cached (NO FileManager saving)
    func loadImage(from urlString: String,
                   into imageView: UIImageView,
                   placeholder: UIImage? = nil) {

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let fileKey = urlString as NSString
        
        // ✅ 1) Check memory cache
        if let cached = imageCache.object(forKey: fileKey) {
            imageView.image = cached
            return
        }

        // Set placeholder if any
        if let placeholder = placeholder {
            imageView.image = placeholder
        }
        
        // ✅ 2) Show loader while downloading
        let loader = UIActivityIndicatorView(style: .medium)
        loader.color = .white
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        
        DispatchQueue.main.async {
            imageView.addSubview(loader)
            NSLayoutConstraint.activate([
                loader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                loader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
        }
        
        // ✅ 3) Download (NO file writing)
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async { loader.removeFromSuperview() }
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Image download failed: \(urlString)")
                return
            }
            
            // Save to memory cache only
            self.imageCache.setObject(image, forKey: fileKey)
            
            DispatchQueue.main.async {
                imageView.image = image
            }
            
        }.resume()
    }
}


//import UIKit
//
//class RemoteImageCacheLoader {
//    static let shared = RemoteImageCacheLoader()
//    
//    private let imageCache = NSCache<NSString, UIImage>()
//    
//    /// Loads image from memory cache → Documents folder → Downloads if needed, shows loader.
//    func loadImage(from urlString: String,
//                   into imageView: UIImageView,
//                   placeholder: UIImage? = nil) {
//
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL: \(urlString)")
//            return
//        }
//        
//        let fileName = url.lastPathComponent
//        let localURL = getDocumentsDirectory().appendingPathComponent(fileName)
//        
//        // ✅ 1) Check memory cache
//        if let cached = imageCache.object(forKey: fileName as NSString) {
//            imageView.image = cached
//            return
//        }
//        
//        // ✅ 2) Check Documents folder
//        if FileManager.default.fileExists(atPath: localURL.path),
//           let localImage = UIImage(contentsOfFile: localURL.path) {
//            imageCache.setObject(localImage, forKey: fileName as NSString)
//            imageView.image = localImage
//            return
//        }
//        
//        // ✅ 3) Show loader while downloading
//        let loader = UIActivityIndicatorView(style: .medium)
//        loader.color = .white 
//        loader.translatesAutoresizingMaskIntoConstraints = false
//        loader.startAnimating()
//        
//        DispatchQueue.main.async {
//            imageView.addSubview(loader)
//            NSLayoutConstraint.activate([
//                loader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
//                loader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
//            ])
//        }
//        
//        // ✅ 4) Download
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            defer {
//                DispatchQueue.main.async {
//                    loader.removeFromSuperview()
//                }
//            }
//            
//            guard let data = data, let image = UIImage(data: data) else {
//                print("Image download failed for: \(urlString)")
//                return
//            }
//            
//            // Save to memory cache
//            self.imageCache.setObject(image, forKey: fileName as NSString)
//            
//            // Save to Documents folder
//            try? data.write(to: localURL)
//            
//            DispatchQueue.main.async {
//                imageView.image = image
//            }
//            
//        }.resume()
//    }
//    
//    private func getDocumentsDirectory() -> URL {
//        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
//}
