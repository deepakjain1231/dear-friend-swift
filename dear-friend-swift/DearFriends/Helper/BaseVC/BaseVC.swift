//
//  BaseVC.swift
//  ToDo
//
//  Created by Himanshu Visroliya on 29/11/22.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc = UIApplication.topViewController2() {
            if (vc is NewProfileVC) || (vc is ExploreVC) || (vc is NewHomeVC) {
                //NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "0"])
            } else {
                NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "1"])
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("BottomView"), object: nil, userInfo: ["hide": "1"])
        }
    }
    
    func changeStyle() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
