//
//  Extension.swift
//  Youunite
//
//  Created by Mac on 26/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

//
//  Extension.swift
//  Dailies Task
//
//  Created by Malav's iMac on 9/9/19.
//  Copyright © 2019 agileimac-7. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Hero

let tabBarTintColor: UIColor = UIColor.red
let navigationBarTitleColor: UIColor = UIColor.black
let navigationBarTintColor: UIColor = UIColor.blue
let navigationBarbarTintColor: UIColor = UIColor.red

extension String {
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + "+"
    }
}

extension CGFloat{
    
    init?(_ str: String) {
        guard let float = Float(str) else { return nil }
        self = CGFloat(float)
    }
    
    func twoDigitValue() -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp //NumberFormatter.roundingMode.roundHalfUp
        
        
        //        let str : NSString = formatter.stringFromNumber(NSNumber(self))!
        let str = formatter.string(from: NSNumber(value: Double(self)))
        return str! as String;
    }
    
    func proportionalFontSize() -> CGFloat {
        
        var sizeToCheckAgainst = self
        
        if(IS_IPAD_DEVICE())    {
            //            sizeToCheckAgainst += 12
        }
        else {
            if(IS_IPHONE_6P_OR_6SP()) {
                sizeToCheckAgainst += 1
            }
            else if(IS_IPHONE_6_OR_6S()) {
                sizeToCheckAgainst += 0
            }
            else if(IS_IPHONE_5_OR_5S()) {
                sizeToCheckAgainst -= 1
            }
            else if(IS_IPHONE_4_OR_4S()) {
                sizeToCheckAgainst -= 2
            }
        }
        return sizeToCheckAgainst
    }
}

extension UIViewController {
    func convertDateFormat(inputDate: String, formate: String = "dd/MM/yyyy") -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let oldDate = olDateFormatter.date(from: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = formate
        
        return convertDateFormatter.string(from: oldDate ?? Date())
    }
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
    // get top most view controller helper method.
    static var topMostViewController : UIViewController {
        get {
            return UIViewController.topViewController(rootViewController: UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
    
    fileprivate static func topViewController(rootViewController: UIViewController) -> UIViewController {
        guard rootViewController.presentedViewController != nil else {
            if rootViewController is UITabBarController {
                let tabbarVC = rootViewController as? UITabBarController ?? UITabBarController()
                let selectedViewController = tabbarVC.selectedViewController
                return UIViewController.topViewController(rootViewController: selectedViewController!)
            }
            
            else if rootViewController is UINavigationController {
                let navVC = rootViewController as? UINavigationController ?? UINavigationController()
                return UIViewController.topViewController(rootViewController: navVC.viewControllers.last!)
            }
            
            return rootViewController
        }
        
        return topViewController(rootViewController: rootViewController.presentedViewController!)
    }
}

public extension UIViewController {
    
    // MARK: - NavigationController Functions
    /// Set Appearance of UINavigationBar.
    func hideshowimg(val:Bool) -> Bool {
        if(val == true)
        {
            return false
        }
        else{
            return true
        }
    }
    
    func setWhiteStatusBar(){
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.white
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
            
        }
    }
    func setblueStatusBar(){
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.ThemeRedColor
            view.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            //      statusbarView.heightAnchor
            //       .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.ThemeRedColor
            
        }
    }
    func setAppearanceOfNavigationBar() {
        
        // Set navigationbar tittle,bar item , backgeound color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = navigationBarTintColor
        self.navigationController?.navigationBar.barTintColor = navigationBarbarTintColor
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: navigationBarTitleColor,
                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0) ]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key: AnyObject]
        
        // Set navigationbar back image(remove 'Back' from navagation)
        let backImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Set status bar
        // self.setStatusBar()
        
        // Set image in navigation title
        // let imageViewTitle = UIImageView(image:ImageNamed(name: "skilliTextLogo"))
        // imageViewTitle.contentMode = .scaleAspectFit
        // self.navigationItem.titleView = imageViewTitle
    }

    /// Set Translucent of UINavigationBar.
    func setTranslucentOfNavigationBar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .AppDefaultColor
        self.navigationController?.navigationBar.backgroundColor = UIColor.AppDefaultColor
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func getClassName() -> String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? ""
    }
    
    /// Hide bottom line from UINavigationBar.
    //    func hideBottomLine() {
    //        self.navigationController?.navigationBar.hideBottomHairline()
    //    }
    
    /// Default push mathord.
    ///
    /// - Parameter viewController: your viewcontroller(String)
    func pushTo(_ viewController: String) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: viewController))!, animated: true)
    }
    
    /// Default pop mathord.
    func popTo() {
        GeneralUtility().addButtonTapHaptic()
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToWithoutAnimation(isHaptic: Bool = true) {
        if isHaptic {
            GeneralUtility().addButtonTapHaptic()
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func goBack(isGoingTab: Bool) {
        self.navigationController?.popViewController(animated: true)
        if isGoingTab {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "0"])
            }
        }
    }
    
    func doPushViewWithAnimation(viewController: UIViewController) {
        GeneralUtility().addButtonTapHaptic()
        
//        self.navigationController?.hero.isEnabled = true
//        self.navigationController?.hero.navigationAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func doPushWithStory(vc: UIViewController, story: UIStoryboard) {
        let vc = story.instantiateViewController(withIdentifier: vc.className)
        self.doPushViewWithAnimation(viewController: vc)
    }
    
    /// Default pop to root controller.
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Default present methord
    ///
    /// - Parameter viewController: your viewcontroller(String)
    func presentTo(_ viewController: String) {
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: viewController)
        let navController = UINavigationController(rootViewController: VC1!)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    /// Default dismiss methord
    func dismissTo() {
        self.navigationController?.dismiss(animated: true, completion: {})
    }
    
    // MARK: - NavigationBar Functions
    /// Remove navigation bar item
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    /// Show or hide navigation bar
    ///
    /// - Parameter isShow: Bool(true, false)
    func showNavigationBar(_ isShow: Bool) {
        self.navigationController?.isNavigationBarHidden = !isShow
    }
    
    // Right,left buttons
    /// Set left side Navigationbar button image.
    ///
    /// - Parameters:
    ///   - Name: set image name
    ///   - selector: return selector
    func setLeftBarButtonImage(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: selector)
        }
    }
    
    /// Set left side Navigationbar button title.
    ///
    /// - Parameters:
    ///   - Name: button name
    ///   - selector: return selector
    func setLeftBarButtonTitle(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: name, style: UIBarButtonItem.Style.plain, target: self, action: selector)
        }
    }
    
    /// Set right side Navigationbar button image.
    ///
    /// - Parameters:
    ///   - Name: set image name
    ///   - selector: return selector
    func setRightBarButtonImage(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: selector)
        }
    }
    
    /// Set right side Navigationbar button title.
    ///
    /// - Parameters:
    ///   - Name: button name
    ///   - selector: return selector
    func setRightBarButtonTitle(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: name, style: UIBarButtonItem.Style.plain, target: self, action: selector)
        }
    }
    
    /// Set right side two Navigationbar button image.
    ///
    /// - Parameters:
    ///   - btn1Name: First button image name
    ///   - selector1: Second button selector
    ///   - btn2Name: First button image name
    ///   - selector2: Second button selector
    func setThreeRightBarButtonImage(_ btn1Name: String, selector1: Selector, btn2Name: String, selector2: Selector, btn3Name: String, selector3: Selector) {
        if self.navigationController != nil {
            let barBtn1: UIBarButtonItem =  UIBarButtonItem(image: UIImage(named: btn1Name), style: .plain, target: self, action: selector1)
            let barBtn2: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: btn2Name), style: .plain, target: self, action: selector2)
            let barBtn3: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: btn3Name), style: .plain, target: self, action: selector3)
            let buttons: [UIBarButtonItem] = [barBtn1, barBtn2,barBtn3]
            self.navigationItem.rightBarButtonItems = buttons
        }
    }
    
    /*
     func setRightBarButtonTitle(_ Name : String, selector : Selector) {
     
     if (self.navigationController != nil) {
     var barButton : UIBarButtonItem = UIBarButtonItem()
     barButton = UIBarButtonItem.init(title:Name.localized, style: UIBarButtonItemStyle.plain, target: self, action: selector)
     barButton.setTitleTextAttributes([ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0),
     NSAttributedStringKey.foregroundColor : UIColor.white,
     NSAttributedStringKey.backgroundColor:UIColor.white],
     for: UIControlState())
     self.navigationItem.rightBarButtonItem = barButton
     }
     }
     */
    
    // MARK: - TabBar Functions
    /// Set TabBar visiblity
    ///
    /// - Parameter visible: Bool
    func setTabBarVisible(visible: Bool) {
        
        if self.tabBarIsVisible() == visible { return }
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -60 : height) ?? 0
        
        self.tabBarController?.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        self.tabBarController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.height + offsetY))
        self.tabBarController?.view.setNeedsDisplay()
        self.tabBarController?.view.layoutIfNeeded()
    }
    
    /// Check TabBar visible or not
    ///
    /// - Returns: Bool(true, false)
    func tabBarIsVisible() -> Bool {
        return self.tabBarController?.tabBar.frame.origin.y ?? 00 < UIScreen.main.bounds.height
    }
    
    /// Set AppearanceOfTabBar
    func setAppearanceOfTabBar() {
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = tabBarTintColor
    }
    
    /// Remove TabBar
    func removeTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    func loginToContinue(){}
    // MARK: - UIViewController Functions
    /// Load your VieweContoller
    ///
    /// - Returns: self
    class func loadController(strStoryBoardName: String = "Main") -> Self {
        return instantiateViewControllerFromMainStoryBoard(strStoryBoardName: strStoryBoardName)
    }
    
    /// Set instantiat ViewController
    ///
    /// - Returns: self
    private class func instantiateViewControllerFromMainStoryBoard<T>(strStoryBoardName: String) -> T {
        guard let controller  = UIStoryboard(name: strStoryBoardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as? T else {
            fatalError("Unable to find View controller with identifier")
        }
        return controller
    }
    
    /// Set status bar background color
    ///
    /// - Parameter color: your color
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    /// Set status bar style
    ///
    /// - Parameter style: statusbar style
    func setStatusBar(style: UIStatusBarStyle = .lightContent) {
        UIApplication.shared.statusBarStyle = style
    }
    
    /// Return Top Controller from window
    static var topMostController: UIViewController {
        if let topVC = UIViewController.topViewController() {
            return topVC
        }
        else if let window =  UIApplication.shared.delegate!.window, let rootVC = window?.rootViewController {
            return rootVC
        }
        return UIViewController()
    }
    
    private class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension UITextField{}
extension UICollectionView {
    
    func setDefaultProperties(vc:UIViewController){
        self.dataSource = vc as? UICollectionViewDataSource
        self.delegate = vc as? UICollectionViewDelegate
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = SemiBoldS18
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {
    /**
     Calculates the total height of the tableView that is required if you ware to display all the sections, rows, footers, headers...
     */
    func contentHeight() -> CGFloat {
        var height = CGFloat(0)
        for sectionIndex in 0..<numberOfSections {
            for rowIndex in 0..<numberOfRows(inSection: sectionIndex){
                height += rectForRow(at: IndexPath.init(row: rowIndex, section: sectionIndex)).size.height
            }
            //            height += rect(forSection: sectionIndex).size.height
        }
        return height
    }
    
}

extension UITableView {
    func setDefaultProperties(vc: UIViewController) {
        self.separatorStyle = .none
        self.dataSource = vc as? UITableViewDataSource
        self.delegate = vc as? UITableViewDelegate
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        messageLabel.font = SemiBoldS16
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func setEmptyMessageWithImage(_ imageName: String) {
        
        let messageLabel = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height / 2))
        messageLabel.image = UIImage(named: imageName)
        messageLabel.contentMode = .scaleAspectFit
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.backgroundView = nil
            self.separatorStyle = .none
            
        }, completion: { completed in
            
        })
    }
}
extension UIViewController{
    func addLabelAnimationborder(sender: UILabel) {
        let storkeLayer = CAShapeLayer()
        storkeLayer.fillColor = UIColor.clear.cgColor
        storkeLayer.strokeColor = UIColor.blue.cgColor
        storkeLayer.lineWidth = 2
        storkeLayer.cornerRadius = sender.cornerRadius
        // Create a rounded rect path using button's bounds.
        storkeLayer.path = CGPath.init(roundedRect: sender.bounds, cornerWidth: sender.cornerRadius, cornerHeight: sender.cornerRadius, transform: nil) // same path like the empty one ...
        // Add layer to the button
        sender.layer.cornerRadius = sender.cornerRadius
        sender.layer.addSublayer(storkeLayer)
        
        // Create animation layer and add it to the stroke layer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        storkeLayer.add(animation, forKey: "circleAnimation")
    }
    func addAnimationborder(sender: UIControl) {
        let storkeLayer = CAShapeLayer()
        storkeLayer.fillColor = UIColor.clear.cgColor
        storkeLayer.strokeColor = UIColor.AppDefaultDarkColor.cgColor
        storkeLayer.lineWidth = 2
        storkeLayer.cornerRadius = sender.cornerRadius
        // Create a rounded rect path using button's bounds.
        storkeLayer.path = CGPath.init(roundedRect: sender.bounds, cornerWidth: sender.cornerRadius, cornerHeight: sender.cornerRadius, transform: nil) // same path like the empty one ...
        // Add layer to the button
        sender.layer.cornerRadius = sender.cornerRadius
        sender.layer.addSublayer(storkeLayer)
        
        // Create animation layer and add it to the stroke layer.
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        storkeLayer.add(animation, forKey: "circleAnimation")
    }
}
extension UIColor {
    
    static let HeaderTitleBlackColor =  UIColor(red: 49.0/255.0, green: 48.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let HeaderInfoGrayColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let PlaceholderGrayColor:UIColor = UIColor.black.withAlphaComponent(0.5)
    static let TextFieldGrayColor:UIColor = UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    static let SubmitButtonColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let TitleButtonColor:UIColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    static let BodyInfoLightGrayColor:UIColor = UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    static let ThemeRedColor:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let Themegradiant1:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let Themegradiant2:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let TextFieldBorderColor:UIColor = UIColor.init(red: 226.0/255.0, green: 230.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let themeBlueColor:UIColor = UIColor.init(red: 61.0/255.0, green: 189.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let cellBorderColor:UIColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let dashedBorder:UIColor = UIColor.init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 0.1)
    
    
    static let bgColour: UIColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    static let themeShadowColor:UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
    
    static let themeGrayColor:UIColor = UIColor.init(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 1.0)
    
    static let themeBlueColorUneri:UIColor = UIColor.init(red: 13/255.0, green: 116/255.0, blue: 148/255.0, alpha: 1.0)
    
    static let themeGreenColorUneri =  UIColor(red: 55.0/255.0, green: 158.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    
    
    static let redColor:UIColor = UIColor.init(red: 250/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    static let orangeColor:UIColor = UIColor.init(red: 248/255.0, green: 90/255.0, blue: 84/255.0, alpha: 1.0)
    
    
    static let yellowColor:UIColor = UIColor.init(red: 255/255.0, green: 196/255.0, blue: 03/255.0, alpha: 1.0)
    
    static let approveColor:UIColor = UIColor.init(red: 100/255.0, green: 183/255.0, blue: 163/255.0, alpha: 1.0)
    
    
    static let healthfirst:UIColor = UIColor.init(red: 98/255.0, green: 108/255.0, blue: 229/255.0, alpha: 1.0)
    
    static let healthsecond:UIColor = UIColor.init(red: 47/255.0, green: 132/255.0, blue: 161/255.0, alpha: 1.0)
    
    
    static let healththird:UIColor = UIColor.init(red: 54/255.0, green: 144/255.0, blue: 155/255.0, alpha: 1.0)
    
    
    static let healthfour:UIColor = UIColor.init(red: 67/255.0, green: 74/255.0, blue: 164/255.0, alpha: 1.0)
    
    static let healthfive:UIColor = UIColor.init(red: 79/255.0, green: 162/255.0, blue: 145/255.0, alpha: 1.0)
    
    
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func themeTintColor() -> UIColor {
        return UIColor.init(red: 0, green: 122, blue: 255)
    }
    
    
}


public extension UIAlertController {
    
    /// Show AlertController with message only
    ///
    /// - Parameters:
    ///   - message: set your message
    ///   - buttonTitles: set button array
    ///   - buttonAction: return button click block
    static func showAlert(withMessage message: String,
                          buttonTitles: [String] = ["Okay"],
                          buttonAction: ((_ index: Int) -> Void)? = nil) {
        var appName = ""
        if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
            appName = name
        }
        
        self.showAlert(withTitle: appName,
                       withMessage: message,
                       buttonTitles: buttonTitles,
                       buttonAction: buttonAction)
        
    }
    
    /// Show AlertController with message and title
    ///
    /// - Parameters:
    ///   - title: set your title
    ///   - message: set your message
    ///   - buttonTitles: set button array
    ///   - buttonAction: return button click block
    static func showAlert(withTitle title: String,
                          withMessage message: String,
                          buttonTitles: [String],
                          buttonAction: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for btn in buttonTitles {
            alertController.addAction(UIAlertAction(title: btn, style: .default, handler: { (_) in
                if let validHandler = buttonAction {
                    validHandler(buttonTitles.firstIndex(of: btn)!)
                }
            }))
        }
        // (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alertController, animated: true, completion: nil)
        UIApplication.shared.delegate!.window!?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    /// Show Actionsheet with message only
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetFromVC(_ viewController: UIViewController,
                                      andMessage message: String,
                                      buttons: [String],
                                      canCancel: Bool,
                                      completion: ((_ index: Int) -> Void)?) {
        var appName = ""
        if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
            appName = name
        }
        
        self.showActionSheetWithTitleFromVC(viewController,
                                            title: appName,
                                            andMessage: message,
                                            buttons: buttons,
                                            canCancel: canCancel,
                                            completion: completion)
    }
    
    /// Show Actionsheet with message and title
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - title: Alert title
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetWithTitleFromCurrentVC(_ message: String,
                                                      buttons: [String],
                                                      canCancel: Bool,
                                                      completion: ((_ index: Int) -> Void)?) {
        
        
        if let viewController = appDelegate.window?.rootViewController
        {
            var appName = ""
            if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
                appName = name
            }
            
            
            
            let alertController = UIAlertController(title: appName, message: message, preferredStyle: .actionSheet)
            
            for index in 0..<buttons.count {
                
                let action = UIAlertAction(title: buttons[index], style: .default, handler: { (_) in
                    if let handler = completion {
                        handler(index)
                    }
                })
                alertController.addAction(action)
            }
            
            if canCancel {
                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    if let handler = completion {
                        handler(buttons.count)
                    }
                })
                
                alertController.addAction(action)
            }
            
            if UIDevice.isIpad {
                
                if viewController.view != nil {
                    alertController.popoverPresentationController?.sourceView = viewController.view
                    alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: (viewController.view?.frame.size.height)!, width: 1.0, height: 1.0)
                } else {
                    alertController.popoverPresentationController?.sourceView = UIApplication.shared.delegate!.window!?.rootViewController!.view
                    alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
                }
            }
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Show Actionsheet with message and title
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - title: Alert title
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetWithTitleFromVC(_ viewController: UIViewController,
                                               title: String,
                                               andMessage message: String,
                                               buttons: [String],
                                               canCancel: Bool,
                                               completion: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: { (_) in
                if let handler = completion {
                    handler(index)
                }
            })
            alertController.addAction(action)
        }
        
        if canCancel {
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                if let handler = completion {
                    handler(buttons.count)
                }
            })
            
            alertController.addAction(action)
        }
        
        if UIDevice.isIpad {
            
            if viewController.view != nil {
                alertController.popoverPresentationController?.sourceView = viewController.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: (viewController.view?.frame.size.height)!, width: 1.0, height: 1.0)
            } else {
                alertController.popoverPresentationController?.sourceView = UIApplication.shared.delegate!.window!?.rootViewController!.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
            }
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}


public extension UIDevice {
    
    enum DeviceType: Int {
        case iPhone4or4s
        case iPhone5or5s
        case iPhone6or6s
        case iPhone6por6sp
        case iPhoneXorXs
        case iPhoneXrorXsMax
        case iPad
    }
    
    /// Check Decide type
    static var deviceType: DeviceType {
        // Need to match width also because if device is in portrait mode height will be different.
        if UIDevice.screenHeight == 480 || UIDevice.screenWidth == 480 {
            return DeviceType.iPhone4or4s
        } else if UIDevice.screenHeight == 568 || UIDevice.screenWidth == 568 {
            return DeviceType.iPhone5or5s
        } else if UIDevice.screenHeight == 667 || UIDevice.screenWidth == 667 {
            return DeviceType.iPhone6or6s
        } else if UIDevice.screenHeight == 736 || UIDevice.screenWidth == 736 {
            return DeviceType.iPhone6por6sp
        } else if UIDevice.screenHeight == 812 || UIDevice.screenWidth == 812 {
            return DeviceType.iPhoneXorXs
        } else if UIDevice.screenHeight == 896 || UIDevice.screenWidth == 896 {
            return DeviceType.iPhoneXorXs
        } else {
            return DeviceType.iPad
        }
    }
    
    /// Check device is Portrait mode
    static var isPortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    /// Check device is Landscape mode
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // MARK: - Device Screen Height
    
    /// Return screen height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // MARK: - Device Screen Width
    
    /// Return screen width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// Return screen size
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// Return device model name
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    // MARK: - Device is iPad
    /// Return is iPad device
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: - Device is iPhone
    
    /// Return is iPhone device
    static var isIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIImage {
    
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}


//MARK:- AIEdge -
enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}


extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}


extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
            ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                      !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    public func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    public func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}



extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    func getDayShort() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "EE"
        return formatter.string(from: self)
    }
    func getMonthFullname() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    func getMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    func getYear() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    func getFullDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    func getFullDateNew() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        // IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN
        // WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE
        // (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME
        // IS GOING TO APPEAR IN SPANISH
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }
        
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    }
    var yearmonthday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self as Date)
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}


extension String {
    func localToUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    func toDate(withFormat format: String )-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //   dateFormatter.locale = Locale(identifier: "fa-IR")
        //dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: self)
        return date
        
    }
    func convertDateFormater(_ date: String,from:String,to:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = to
        return  dateFormatter.string(from: date!)
        
    }
    public func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    //    var localized: String {
    //        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    //    }
}
extension UIDevice {
    @available(iOS 11.0, *)
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
}

extension String {
    var StrTobool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    var boolValue: Bool {
        
        return (self as NSString).boolValue
    }}
public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat,selected:UIColor) {
        let border = CALayer()
        border.backgroundColor = selected.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    
    func alignVerticalCenter(padding: CGFloat = 7.0) {
        guard let imageSize = imageView?.frame.size, let titleText = titleLabel?.text, let titleFont = titleLabel?.font else {
            return
        }
        
        let titleSize = (titleText as NSString).size(withAttributes: [.font: titleFont])
        print(titleSize)
        let totalHeight = imageSize.height + titleSize.height + padding
        let totalwidth = self.frame.width
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: ((totalwidth - imageSize.width)/2), bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(totalHeight - titleSize.height), right: -((totalwidth - titleSize.width)/2))
    }
}
extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension UILabel {
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    @IBInspectable var addKern : CGFloat {
        get {
            return self.addKern
        }
        set {
            if let att = attributedText as? NSMutableAttributedString {
                print("att",att)
                att.addAttributes([NSAttributedString.Key.kern: newValue], range: ((self.text ?? "") as NSString).fullrange())
                self.attributedText = att
            }else {
                self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.kern: newValue])
            }
        }
    }
    
    @IBInspectable var addLineHeight : CGFloat {
        get {
            return self.addLineHeight
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = newValue
            paragraphStyle.alignment = self.textAlignment
            
            if let att = attributedText as? NSMutableAttributedString {
                print("att",att)
                att.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: ((self.text ?? "") as NSString).fullrange())
                self.attributedText = att
            }else {
                self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            }
        }
    }
}

extension NSString {
    func fullrange() -> NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundedValues(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension NSAttributedString {
    
    convenience init?(withLocalizedHTMLString: String) {
        
        guard let stringData = withLocalizedHTMLString.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html as Any,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        try? self.init(data: stringData, options: options, documentAttributes: nil)
    }
}


//MARK:- tableview register
extension UITableView {
    func registerNib(_ className : UITableViewCell?) {
        self.register(UINib(nibName: "\(className)", bundle: nil), forCellReuseIdentifier: "\(className)")
    }
}
public extension UITableView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell
     - Parameter type: UITableViewCell.Type
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK- uicollectionview cell register
extension UICollectionView {
    func registerNib(_ className : UICollectionViewCell?) {
        self.register(UINib(nibName: "\(className)", bundle: nil), forCellWithReuseIdentifier: "\(className)")
    }
}
public extension UICollectionView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    /**
     DequeueCell by passing the type of UICollectionViewCell and IndexPath
     - Parameter type: UICollectionViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - scrollview index
extension UIScrollView {
    
    public var currentPage : Int {
        let pageWidth = self.frame.size.width
        return Int((self.contentOffset.x + pageWidth / 2) / pageWidth)
    }
}

extension UIView {
    
    @IBInspectable var isAddGradient : Bool {
        get {
            return self.isAddGradient
        }
        set {
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.addGradient()
                }
            }
        }
    }
    
    func addGradient() {
        let layer0 = CAGradientLayer()
        layer0.colors = [hexStringToUIColor(hex: "#F29A56"),
                         hexStringToUIColor(hex: "#FFE1AC")]
        
        self.layer.sublayers?.forEach({ (lyer) in
            if lyer.isKind(of: CAGradientLayer.self) {
                lyer.removeFromSuperlayer()
            }
        })
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.frame = self.bounds
        layer0.cornerRadius = self.cornerRadius
        if self.layer.sublayers?.count != 0 {
            self.layer.insertSublayer(layer0, at: 0)
        }else {
            self.layer.addSublayer(layer0)
        }
    }
}

//MARK:- typeCaste string to int, double
extension String {
    var integerValue : Int {
        return (self as NSString).integerValue
    }
    
    var doubleValue : Double {
        return (self as NSString).doubleValue
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


extension UISearchBar {
    var enableCancelButton : Bool{
        get {
            return self.enableCancelButton
        }
        set {
            if let cancelButton = self.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = newValue
            }
        }
    }
}

extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}

func sizePerMB(url: URL?) -> Double {
    guard let filePath = url?.path else {
        return 0.0
    }
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber {
            return size.doubleValue / 1000000.0
        }
    } catch {
        print("Error: \(error)")
    }
    return 0.0
}


func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

func removeUrlFromFileManager(_ outputFileURL: URL?) {
    if let outputFileURL = outputFileURL {
        
        let path = outputFileURL.path
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                print("url SUCCESSFULLY removed: \(outputFileURL)")
            } catch {
                print("Could not remove file at url: \(outputFileURL)")
            }
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}

//HTML text to string
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension CACornerMask {
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
}

extension URL {
    func getDocumentName() -> String{
        return self.lastPathComponent
    }
    
    func getDocumentFileType() -> String {
        return self.lastPathComponent.components(separatedBy: ".").last ?? ""
    }
}

extension String {
    func manageNullStrings() -> String {
        if self.isEmpty || self.lowercased() == "null" || self.lowercased() == "<null>" {
            return "N/A"
        }
        return self
    }
}

extension UIViewController {
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}


extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], direction: GradientDirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
      //  locations = [0.0, 0.55]
//        startPoint = CGPoint(x: 1.0, y: 0.5)
//        endPoint = CGPoint(x: 0.0, y: 0.5)
        
        switch direction {
        case .Right:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        case .Left:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
        case .TopLeftToBottomRight:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .TopRightToBottomLeft:
            startPoint = CGPoint(x: 1.0, y: 0.0)
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .BottomLeftToTopRight:
            startPoint = CGPoint(x: 0.0, y: 1.0)
            endPoint = CGPoint(x: 1.0, y: 0.0)
        default:
            startPoint = CGPoint(x: 1.0, y: 1.0)
            endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}


extension UIView.KeyframeAnimationOptions {
  
  static var curveEaseIn: UIView.KeyframeAnimationOptions {
    UIView.KeyframeAnimationOptions(animationOptions: .curveEaseIn)
  }
  
  static var curveEaseOut: UIView.KeyframeAnimationOptions {
    UIView.KeyframeAnimationOptions(animationOptions: .curveEaseOut)
  }
  
  static var curveEaseInOut: UIView.KeyframeAnimationOptions {
    UIView.KeyframeAnimationOptions(animationOptions: .curveEaseInOut)
  }
  
  static var curveLinear: UIView.KeyframeAnimationOptions {
    UIView.KeyframeAnimationOptions(animationOptions: .curveLinear)
  }
  
  init(animationOptions: UIView.AnimationOptions) {
    self.init(rawValue: animationOptions.rawValue)
  }
}
