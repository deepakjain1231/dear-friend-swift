//
//  NewPasswordVC.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 04/12/24.
//

import UIKit
import BottomPopup

class NewPasswordVC: BottomPopupViewController {
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnYes: AppButton!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwCancel: UIView!
    
    @IBOutlet weak var txtPass: AppCommonTextField!
    @IBOutlet weak var txtPassConf: AppCommonTextField!

    
    // MARK: - VARIABLES
    
    var titleStr = ""
    var isForceUpdate = false
    var isForVersion = false
    var leftStr = ""
    var rightStr = ""
    
    var height: CGFloat = 0.0
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var shouldBeganDismiss: Bool?
    
    override var popupHeight: CGFloat { return height }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    override var popupShouldBeganDismiss: Bool { return shouldBeganDismiss ?? true }
    
    var yesTapped: voidCloser?
    var noTapped: voidCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = self.titleStr
        
        if self.leftStr != "" {
            self.lblNo.text = self.leftStr
        }
        
        if self.rightStr != "" {
            self.btnYes.setTitle(self.rightStr, for: .normal)
        }
        
        if self.isForVersion {
            self.lblNo.text = "CANCEL"
            self.btnYes.setTitle("UPDATE", for: .normal)
            if self.isForceUpdate {
                self.vwCancel.isHidden = true
            } else {
                self.vwCancel.isHidden = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.relosdMYPage(_:)), name: Notification.Name("RelodPopup"), object: nil)
        
        self.btnYes.titleLabel?.numberOfLines = 0
        self.btnYes.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnYes.titleLabel?.textAlignment = .center
    }
    
    @objc func relosdMYPage(_ notification: NSNotification) {
        if let Message = notification.userInfo?["Message"] as? String {
            self.lblTitle.text = Message
        }
        if let isForceUpdate = notification.userInfo?["isForceUpdate"] as? Bool {
            self.isForceUpdate = isForceUpdate
            if self.isForVersion {
                self.lblNo.text = "CANCEL"
                self.btnYes.setTitle("UPDATE", for: .normal)
                if self.isForceUpdate {
                    self.vwCancel.isHidden = true
                } else {
                    self.vwCancel.isHidden = false
                }
            }
        }
    }
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnNoTapped(_ sender: UIButton) {
        self.noTapped?()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnYesTapped(_ sender: UIButton) {
        
        if self.txtPass.text == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMissing)
            return
        }
        
        if self.txtPass.text?.count ?? 0 < 6 {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMinMissing)
            return
        }
        
        if self.txtPassConf.text == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.ConfirmPasswordMissing)
            return
        }
        
        if self.txtPassConf.text?.count ?? 0 < 6 {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMinMissing)
            return
        }
        
        if self.txtPass.text != self.txtPassConf.text {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordNotMatch2)
            return
        }
        
        UserDefaults.standard.set(self.txtPass.text, forKey: "newPassword")
        self.yesTapped?()
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods
