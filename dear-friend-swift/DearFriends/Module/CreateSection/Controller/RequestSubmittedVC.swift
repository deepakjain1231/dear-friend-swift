//
//  RequestSubmittedVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/10/23.
//

import UIKit

class RequestSubmittedVC: UIViewController {
    
    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    
    var customVM = CreateCustomAudioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if let vc = self.navigationController?.viewControllers.last(where: { $0.isKind(of: CustomAudioRequestVC.self) }) {
            self.navigationController?.popToViewController(ofClass: CustomAudioRequestVC.self)
        } else {
            let vc: CustomAudioRequestVC = CustomAudioRequestVC.instantiate(appStoryboard: .CreateMusic)
            vc.hidesBottomBarWhenPushed = true
            vc.customVM = self.customVM
            vc.isFromSuccess = true
            UIApplication.topViewController2()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
