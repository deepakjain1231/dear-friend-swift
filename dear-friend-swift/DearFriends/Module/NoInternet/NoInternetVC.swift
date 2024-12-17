//
//  NoInternetVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 06/06/23.
//

import UIKit

class NoInternetVC: BaseVC {
    
    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnTryAgainTapped(_ sender: UIButton) {
        if Reach().connectionStatus().description != ReachabilityStatus.offline.description {
            appDelegate.manageNoNet()
        } else {
            GeneralUtility().showErrorMessage(message: "No Internet Connection!!")
        }
    }
    
    @IBAction func btnDownloadsTapped(_ sender: UIButton) {
        let vc: MyHistoryVC = MyHistoryVC.instantiate(appStoryboard: .Profile)
        vc.currentScreen = .download
        vc.hidesBottomBarWhenPushed = true
        vc.isFromNoNet = true
        
        if let nav = self.navigationController {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let nav: UINavigationController = UINavigationController(rootViewController: self)
            nav.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
