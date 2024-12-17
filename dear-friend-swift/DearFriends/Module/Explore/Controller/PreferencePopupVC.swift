//
//  PreferencePopupVC.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 12/12/24.
//

import UIKit

class PreferencePopupVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAppstoreTapped(_ sender: Any) {
        self.dismiss(animated: true)
        UserDefaults.standard.setValue(true, forKey: updatePreferences)
        self.openAppStoreLink()
    }
    
    func openAppStoreLink() {
        let vc: MyPreferencesVC = MyPreferencesVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
