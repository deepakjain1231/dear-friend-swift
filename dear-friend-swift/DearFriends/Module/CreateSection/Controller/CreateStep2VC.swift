//
//  CreateStep2VC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 19/10/23.
//

import UIKit

class CreateStep2VC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.btn1.titleLabel!.lineBreakMode = .byWordWrapping
        self.btn1.titleLabel!.textAlignment = .center
        self.btn2.titleLabel!.numberOfLines = 2
        self.btn2.titleLabel!.textAlignment = .center
        self.vw1.borderWidth = 0
        self.vw2.borderWidth = 0
        self.vw1.backgroundColor = hexStringToUIColor(hex: "#212159")
        self.vw2.backgroundColor = hexStringToUIColor(hex: "#212159")
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if self.vw1.borderWidth == 1 {
            let vc: UploadScriptVC = UploadScriptVC.instantiate(appStoryboard: .CreateMusic)
            vc.customVM = self.customVM
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc: ScriptHelpVC = ScriptHelpVC.instantiate(appStoryboard: .CreateMusic)
            vc.customVM = self.customVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnScripTaped(_ sender: UIButton) {
        if sender.tag == 0 {
            self.vw1.borderWidth = 1
            self.vw2.borderWidth = 0
            self.vw1.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            self.vw2.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.customVM.script_file = "yes"
            
            let vc: UploadScriptVC = UploadScriptVC.instantiate(appStoryboard: .CreateMusic)
            vc.customVM = self.customVM
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.vw2.borderWidth = 1
            self.vw1.borderWidth = 0
            self.vw2.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            self.vw1.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.customVM.script_file = "no"
            
            let vc: ScriptHelpVC = ScriptHelpVC.instantiate(appStoryboard: .CreateMusic)
            vc.customVM = self.customVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
