//
//  ContactPermission.swift
//  GiftApp
//
//  Created by Jigar Khatri on 24/10/24.

import UIKit



class AppRatePopup: UIView {

    //VIEW
    @IBOutlet weak var subView: UIView!
    @IBOutlet var mainView: UIView!
   
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDetails: UILabel!

    @IBOutlet var viewAppStore: UIView!
    @IBOutlet var lblAppStore: UILabel!

    
  
    
        // method to load reasons xib.
    func loadPopUpView() {
        // ContactUS name of the XIB.
        Bundle.main.loadNibNamed("AppRatePopup", owner:self, options:nil)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.subView.layer.cornerRadius = 20.0
        self.mainView.frame = self.bounds
        self.addSubview(self.mainView)
        self.mainView.layoutIfNeeded()
        
        
        //SET ANIMATION
        self.subView.transform = CGAffineTransform(scaleX: 0.2, y:0.2)
        UIView.animate(withDuration:1.0, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                self.subView.transform = CGAffineTransform(scaleX: 1.0, y:1.0)
        }, completion:nil)
        

        //SET FONT
        self.setTheView()
    }
    
    func removeViewWithAnimation() {
        self.subView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.1, animations: {
            self.subView.transform = CGAffineTransform(scaleX: 1.01, y:1.01)
        } ,completion:{ (finished) in
            if(finished) {
                self.alpha = 1.0
                UIView.animate(withDuration:0.5, animations: {
                    self.alpha = 0
                    self.subView.transform = CGAffineTransform(scaleX: 0.2, y:0.2)
                }, completion: { (finished) in
                    if(finished) {
                        self.removeFromSuperview()
                    }
                })
            }
        })
    }
    

    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 24, text: "Share the Love!")
        self.lblDetails.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "Thank you for being a part of Dear Friends. Please consider leaving a review to help us grow our presence and refine your experience.")
   
        self.lblAppStore.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_SemiBold, fontSize: 18, text: "App Store")

        //SET VIEW
        self.subView.viewCorneRadius(radius: 20)
        self.subView.backgroundColor = .primary

        self.viewAppStore.viewCorneRadius(radius: 0)
        self.viewAppStore.backgroundColor = .buttonBGColor
    }
    
    //......................... OTHER FUNCION .........................//
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.removeViewWithAnimation()
    }
    
    @IBAction func btnAppstoreTapped(_ sender: Any) {
        self.removeViewWithAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            UserDefaults.standard.setValue(true, forKey: userRatedApp)
            self.openAppStoreLink()
        }
        
    }
    
    func openAppStoreLink() {
        if let url = URL(string: "https://apps.apple.com/us/app/dear-friends/id6477375969"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open the App Store link.")
        }
    }
}



