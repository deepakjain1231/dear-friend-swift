//
//  LoaderClass.swift
//  DemoServiceManage
//
//  Created by Zestbrains on 11/06/21.
//

import Foundation
import NVActivityIndicatorView
import UIKit
import Lottie

class LoadingDailog: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: - Shared Instance
    static let sharedInstance : LoadingDailog = {
        let instance = LoadingDailog()
        return instance
    }()
    
    func startLoader() {
        //.AppBlue()
        startAnimating(nil, message: nil, messageFont: nil, type: .lineScalePulseOut, color: hexStringToUIColor(hex: "#776ADA"), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    func stopLoader() {
        self.stopAnimating()
    }
}

//class NewLoadingDailog: UIViewController {
//
//    private var animationView: AnimationView?
//
//    //MARK: - Shared Instance
//    static let sharedInstance : NewLoadingDailog = {
//        let instance = NewLoadingDailog()
//        return instance
//    }()
//
//    override func viewDidLoad(){
//
//    }
//
//    func startLoader() {
//
//        animationView = .init(name: "LoaderAnimation")
//        animationView!.frame = view.bounds
//        animationView!.contentMode = .scaleAspectFit
//        animationView!.loopMode = .loop
//        animationView!.animationSpeed = 1.5
//        animationView!.backgroundColor = UIColor.App_BG_Blue_Color.withAlphaComponent(0.8)
//       // view.addSubview(animationView!)
//
//        guard let keyWindow = UIApplication.shared.keyWindow else { return }
//
//        if !animationView!.isDescendant(of: keyWindow) {
//
//            keyWindow.subviews.forEach { (vw) in
//                if vw is AnimationView {
//                    vw.removeFromSuperview()
//                }
//            }
//            keyWindow.addSubview(animationView!)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.animationView!.play()
//        }
//    }
//
//    func stopLoader() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.animationView?.stop()
//            self.animationView?.fadeOut()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.animationView?.removeFromSuperview()
//            }
//        }
//    }
//}

//MARK: HIDE/SHOW LOADERS
public func HIDE_CUSTOM_LOADER() {
    LoadingDailog.sharedInstance.stopLoader()
    //NewLoadingDailog.sharedInstance.stopLoader()
}

public func SHOW_CUSTOM_LOADER() {
    LoadingDailog.sharedInstance.startLoader()
//    NewLoadingDailog.sharedInstance.startLoader()
}

//MARK: Loading indicater and Alert From UIVIEWController
extension UIViewController {
    
    //MARK: - Show/Hide Loading Indicator
    func SHOW_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.startLoader()
//        NewLoadingDailog.sharedInstance.startLoader()
    }
    
    func HIDE_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.stopLoader()
//        NewLoadingDailog.sharedInstance.stopLoader()
    }
}
