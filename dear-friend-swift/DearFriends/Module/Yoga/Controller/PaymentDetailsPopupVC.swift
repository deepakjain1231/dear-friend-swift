//
//  PaymentDetailsPopupVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import BottomPopup

class PaymentDetailsPopupVC: BottomPopupViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblFinal: UILabel!
    @IBOutlet weak var lblCharge: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    
    // MARK: - VARIABLES
    
    var finalAmountMain = ""
    
    var height: CGFloat = 0.0
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var shouldBeganDismiss: Bool?
    
    override var popupHeight: CGFloat { return height }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(16) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    override var popupShouldBeganDismiss: Bool { return shouldBeganDismiss ?? true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblFinal.text = "\(smallAppCurrency)\(appDelegate.finalAmountMain)"
        self.lblSubTotal.text = "\(smallAppCurrency)\(appDelegate.finalAmountMain)"
        self.lblCharge.text = "\(smallAppCurrency)\("0.00")"
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
