//
//  SettingsVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 12/05/23.
//

import UIKit

class SettingsVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblNavTitle: UILabel!
    
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblTermsCondition: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblDeleteAccount: UILabel!
    
    @IBOutlet weak var imgChangePassword: UIImageView!
    @IBOutlet weak var imgTermsCondition: UIImageView!
    @IBOutlet weak var imgPrivacyPolicy: UIImageView!
    @IBOutlet weak var imgDeleteAccount: UIImageView!
    
    @IBOutlet weak var imgChangePassword_arrow: UIImageView!
    @IBOutlet weak var imgTermsCondition_arrow: UIImageView!
    @IBOutlet weak var imgPrivacyPolicy_arrow: UIImageView!
    @IBOutlet weak var imgDeleteAccount_arrow: UIImageView!
    
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewTermsCondition: UIView!
    @IBOutlet weak var viewPrivacyPolicy: UIView!
    @IBOutlet weak var viewDeleteAccount: UIView!
    
    
    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupImage()
        self.changeStyle()
        
        if CurrentUser.shared.user?.is_social == "1" {
            self.viewChangePassword.isHidden = true
        }
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Settings")
        
        self.lblChangePassword.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Change Passowrd")
        self.lblTermsCondition.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Terms & Conditions")
        self.lblPrivacyPolicy.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Privacy Policy")
        self.lblDeleteAccount.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Delete Account")
        
        //SET VIEW
        self.viewChangePassword.viewCorneRadius(radius: 8)
        self.viewChangePassword.backgroundColor = .primary
        self.viewChangePassword.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewTermsCondition.viewCorneRadius(radius: 8)
        self.viewTermsCondition.backgroundColor = .primary
        self.viewTermsCondition.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewPrivacyPolicy.viewCorneRadius(radius: 8)
        self.viewPrivacyPolicy.backgroundColor = .primary
        self.viewPrivacyPolicy.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewDeleteAccount.viewCorneRadius(radius: 8)
        self.viewDeleteAccount.backgroundColor = .primary
        self.viewDeleteAccount.viewBorderCorneRadius(borderColour: .secondary)

        self.imgChangePassword_arrow.viewCorneRadius(radius: 9)
        self.imgTermsCondition_arrow.viewCorneRadius(radius: 9)
        self.imgPrivacyPolicy_arrow.viewCorneRadius(radius: 9)
        self.imgDeleteAccount_arrow.viewCorneRadius(radius: 9)
    }
    
    func setupImage() {
        self.imgChangePassword.image = UIImage.init(named: "ic_change_pass")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgChangePassword.tintColor = .secondary
        
        self.imgTermsCondition.image = UIImage.init(named: "ic_terms")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgTermsCondition.tintColor = .secondary
        
        self.imgPrivacyPolicy.image = UIImage.init(named: "ic_privacy")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgPrivacyPolicy.tintColor = .secondary
        
        self.imgDeleteAccount.image = UIImage.init(named: "ic_delete")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.imgDeleteAccount.tintColor = .secondary
    }
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnMenuTaped(_ sender: UIButton) {
        if sender.tag == 2 {
            let vc: ChangePasswordVC = ChangePasswordVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, view_bg: self.viewChangePassword, img_arrow: self.imgChangePassword_arrow, current_vc: vc)
        }
        if sender.tag == 3 {
            let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
            vc.currentType = .termCondition
            self.push_screen(indx_tag: sender.tag, view_bg: self.viewTermsCondition, img_arrow: self.imgTermsCondition_arrow, current_vc: vc)
        }
        if sender.tag == 4 {
            let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
            vc.currentType = .privacyPolicy
            self.push_screen(indx_tag: sender.tag, view_bg: self.viewPrivacyPolicy, img_arrow: self.imgPrivacyPolicy_arrow, current_vc: vc)
        }
        if sender.tag == 5 {
            let vc: DeleteReasonVC = DeleteReasonVC.instantiate(appStoryboard: .Profile)
            self.push_screen(indx_tag: sender.tag, view_bg: self.viewDeleteAccount, img_arrow: self.imgDeleteAccount_arrow, current_vc: vc)
        }
        if sender.tag == 6 {
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "CommonBottomPopupVC") as? CommonBottomPopupVC
            popupVC?.height = 250
            popupVC?.presentDuration = 0.3
            popupVC?.dismissDuration = 0.3
            popupVC?.titleStr = "Are you sure you want to logout from this account?"
            popupVC?.yesTapped = {
                CurrentUser.shared.logoutUser()
            }
            DispatchQueue.main.async {
                self.present(popupVC!, animated: true, completion: nil)
            }
        }
    }
    
    
    func push_screen(indx_tag: Int, view_bg: UIView, img_arrow: UIImageView?, current_vc: UIViewController) {

        UIView.animate(withDuration: 0.2) {
            
            if indx_tag == 2 {
                self.imgChangePassword.tintColor = .primary
            }
            else if indx_tag == 3 {
                self.imgTermsCondition.tintColor = .primary
            }
            else if indx_tag == 4 {
                self.imgPrivacyPolicy.tintColor = .primary
            }
            else if indx_tag == 5 {
                self.imgDeleteAccount.tintColor = .primary
            }
            
            view_bg.backgroundColor = .secondary
            view_bg.viewBorderCorneRadius(borderColour: .primary)
            
            if img_arrow != nil {
                img_arrow?.viewBorderCorneRadius(borderColour: .primary)
            }

        } completion: { completed in
            
            if indx_tag == 5 {
                DispatchQueue.main.async {
                    self.present(current_vc, animated: true, completion: nil)
                }
            }
            else {
                current_vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(current_vc, animated: true)
            }
            
            self.screen_back_refresh()
        }
    }
    
    func screen_back_refresh() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timerrr in
            timerrr.invalidate()
            self.setTheView()
            self.setupImage()
        }
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods
