//
//  RequestEditPopupVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit
import BottomPopup
import IQKeyboardManagerSwift
//import IQTextView

class RequestEditPopupVC: BottomPopupViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var txtView: IQTextView!
    
    // MARK: - VARIABLES
    
    var submitText: stringCloser?
    
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
        self.txtView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        if (self.txtView.text ?? "") == "" {
            GeneralUtility().showErrorMessage(message: "Please add description")
            return
        }
        self.submitText?(self.txtView.text ?? "")
        self.dismiss(animated: true)
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods
