//
//  AppRatePopupVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 16/10/24.
//

import UIKit

class AppRatePopupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAppstoreTapped(_ sender: Any) {
        self.dismiss(animated: true)
        UserDefaults.standard.setValue(true, forKey: userRatedApp)
        self.openAppStoreLink()
    }
    
    func openAppStoreLink() {
        if let url = URL(string: "https://apps.apple.com/us/app/dear-friends/id6477375969"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open the App Store link.")
        }
    }
}
