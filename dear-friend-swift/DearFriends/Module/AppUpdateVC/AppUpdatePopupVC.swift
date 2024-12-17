//
//  AppUpdatePopupVC.swift
//  foodberry-driver
//
//  Created by Zestbrains on 26/04/21.
//

import UIKit

class AppUpdatePopupVC: UIViewController {
    
    var isForceUpdate:Bool = false
    
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var lblTitle: GradientLabel!
    @IBOutlet weak var BtnCancel: UIButton!
    @IBOutlet weak var BtnUpdate: UIButton!
    @IBOutlet weak var LblMessage: UILabel!
    var ErrorMessage = String()
    var isForLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.LblMessage.text = ErrorMessage
        self.lblTitle.gradientColors = [hexStringToUIColor(hex: "#F29A56").cgColor,
                                        hexStringToUIColor(hex: "#FFE1AC").cgColor]
        
        if (self.isForceUpdate == true) {
            self.BtnCancel.isHidden = true
            self.vwCancel.isHidden = true
            
        } else {
            self.BtnCancel.isHidden = false
            self.vwCancel.isHidden = false
        }
        
        if isForLocation {
            self.lblTitle.text = "Location Permission"
            self.BtnCancel.setTitle("Cancel", for: .normal)
            self.BtnUpdate.setTitle("SETTING", for: .normal)
        }
    }
    
    @IBAction func BtnCancelAction(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnUpdateAction(_ sender:UIButton) {
        if isForLocation {
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            
        } else {
            let appID : String = "" //write here the app
            if let url  = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
               UIApplication.shared.canOpenURL(url) {
                guard let url = URL(string: "\(url)"), !url.absoluteString.isEmpty else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                if let url = URL(string: "https://apps.apple.com/us/app/the-bin-app/id1554985912") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

//MARK:- functions for the viewController
func HideAppUpdatePopup() {
    if let popupViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CommonBottomPopupVC") as? CommonBottomPopupVC {
        popupViewController.modalPresentationStyle = .custom
        popupViewController.modalTransitionStyle = .crossDissolve
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            if(topController == popupViewController) {
                popupViewController.dismiss(animated: true, completion: nil)
            } else {
                if let presented = UIApplication.topViewController2() {
                    if presented is AppUpdatePopupVC {
                        presented.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

func showAppUpdatePopup(isForceUpdate: Bool,Message: String, isForLocation: Bool = false) {
    //creating a reference for the dialogView controller
    
    if let popupViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CommonBottomPopupVC") as? CommonBottomPopupVC {
        
        popupViewController.height = 250
        popupViewController.presentDuration = 0.1
        popupViewController.dismissDuration = 0.1
        popupViewController.shouldDismissInteractivelty = false
        popupViewController.titleStr = Message
        popupViewController.shouldBeganDismiss = false
        popupViewController.isForVersion = true
        popupViewController.isForceUpdate = isForceUpdate
        
        popupViewController.yesTapped = {
            let appID : String = ""
            if let url  = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
               UIApplication.shared.canOpenURL(url) {
                guard let url = URL(string: "\(url)"), !url.absoluteString.isEmpty else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if let url = URL(string: "https://apps.apple.com/us/app/the-bin-app/id1554985912") {
                    UIApplication.shared.open(url)
                }
            }
        }

        if UIApplication.topViewController2() is UIAlertController {
            UIApplication.topViewController2()?.dismiss(animated: false, completion: {
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    topController.present(popupViewController, animated: true)
                }
            })
        } else {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(popupViewController, animated: true)
            }
        }
    }
}
