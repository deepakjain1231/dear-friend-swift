//
//  ChangePasswordVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 12/05/23.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblOldPasswordTitle: UILabel!
    @IBOutlet weak var lblNewPasswordTitle: UILabel!
    @IBOutlet weak var lblConfirmPasswordTitle: UILabel!
    
    @IBOutlet weak var txtConfirm: AppCommonTextField!
    @IBOutlet weak var txtNew: AppCommonTextField!
    @IBOutlet weak var txtOld: AppCommonTextField!
    
    @IBOutlet weak var viewOldPassword: UIView!
    @IBOutlet weak var viewNewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var btnSubmit: AppButton!
    
    // MARK: - VARIABLES
    
    var changePassVM = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTheView()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Change Password")
        
        self.lblOldPasswordTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Current Password")
        self.lblNewPasswordTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "New Password")
        self.lblConfirmPasswordTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Confirm New Password")
        
        self.txtOld.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "", placeholder: "Enter your password")
        self.txtNew.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "", placeholder: "Enter your password")
        self.txtConfirm.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "", placeholder: "Enter your password")
        
        self.txtNew.LeftPadding = 0
        self.txtOld.LeftPadding = 0
        self.txtConfirm.LeftPadding = 0
        self.txtNew.backgroundColor = .clear
        self.txtOld.backgroundColor = .clear
        self.txtConfirm.backgroundColor = .clear
        
        //SET VIEW
        self.viewOldPassword.viewCorneRadius(radius: 8)
        self.viewOldPassword.backgroundColor = .primary
        self.viewOldPassword.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewNewPassword.viewCorneRadius(radius: 8)
        self.viewNewPassword.backgroundColor = .primary
        self.viewNewPassword.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewConfirmPassword.viewCorneRadius(radius: 8)
        self.viewConfirmPassword.backgroundColor = .primary
        self.viewConfirmPassword.viewBorderCorneRadius(borderColour: .secondary)
        
        self.btnSubmit.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Continue")
        self.btnSubmit.backgroundColor = UIColor.init(named: "Button_BG_Color")
    }
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: false)
    }
    
    @IBAction func btnChangeTapped(_ sender: UIButton) {
        GeneralUtility().addButtonTapHaptic()
        self.view.endEditing(true)
        
        self.changePassVM.cpassword = self.txtConfirm.text ?? ""
        self.changePassVM.npassword = self.txtNew.text ?? ""
        self.changePassVM.opassword = self.txtOld.text ?? ""
        
        self.changePassVM.ChangePassword { response in
            self.goBack(isGoingTab: false)
        } failure: { errorResponse in
            
        }
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods
