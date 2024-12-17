//
//  CreateSectionVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 22/09/23.
//

import UIKit

class CreateSectionVC: UIViewController {
    
    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    
    static var newInstance: CreateSectionVC {
        let storyboard = UIStoryboard(name: "CreateMusic", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "CreateSectionVC"
        ) as! CreateSectionVC
        return vc
    }
    
    var isFromInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        let vc: CreateSection2VC = CreateSection2VC.instantiate(appStoryboard: .CreateMusic)
        vc.isFromInfo = self.isFromInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
