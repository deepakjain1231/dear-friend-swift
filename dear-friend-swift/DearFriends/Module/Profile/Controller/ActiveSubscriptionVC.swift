//
//  ActiveSubscriptionVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import SwiftDate

class ActiveSubscriptionVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    
    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "My Subscription")
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblName.text = CurrentUser.shared.user?.name ?? ""
        if appDelegate.isPlanPurchased {
            self.lblStatus.text = "Active"
        } else {
            self.lblStatus.text = "Expired"
        }
        
        if CurrentUser.shared.user?.planType == "" && appDelegate.isPlanPurchased {
            let expDate = CurrentUser.shared.user?.expiryDate?.toDate()?.convertTo(region: .local).toFormat("dd MMM, yyyy")
            self.lblPrice.isHidden = true
            self.lblExpiry.text = expDate
            self.lblDuration.text = "Free Trial"
            
        } else {
            self.lblExpiry.text = CurrentUser.shared.user?.expiryDate?.toDate()?.convertTo(region: .local).toFormat("dd MMM, yyyy")
            self.lblPrice.isHidden = false
            if (CurrentUser.shared.user?.planType ?? "") == "yearly" {
                self.lblPrice.text = "$49.99"
                self.lblDuration.text = "Year"
            } else if (CurrentUser.shared.user?.planType ?? "") == "monthly" {
                self.lblPrice.text = "$6.99"
                self.lblDuration.text = "Month"
            } else {
                self.lblPrice.text = "-"
                self.lblDuration.text = "-"
                self.lblExpiry.text = "-"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
        
    @IBAction func btnChangeTapped(_ sender: UIButton) {
        let vc: SubscriptionVC = SubscriptionVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
