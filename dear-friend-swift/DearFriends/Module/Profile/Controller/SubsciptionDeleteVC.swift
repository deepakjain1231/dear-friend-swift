//
//  SubsciptionDeleteVC.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 25/12/24.
//

import UIKit
import BottomPopup

class SubsciptionDeleteVC:  BottomPopupViewController {
    
    @IBOutlet weak var lbl_ConfirmDeleteTitle: UILabel!
    @IBOutlet weak var lbl_ConfirmDeletesubTitle: UILabel!
    
    @IBOutlet weak var lblReason_subTitle: UILabel!
    @IBOutlet weak var btn_delete: AppButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnClose: UIButton!

    var reason = ""
    var explenation = ""
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
    }
    
    //SET THE VIEW
    func setTheView() {
        buttonImageColor(btnImage: self.btnClose, imageName: "ic_close2", colorHex: .background)

        //SET FONT
        self.lbl_ConfirmDeleteTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 20, text: "Confirm Delete")
        self.lbl_ConfirmDeletesubTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Confirm to Permanently Delete Your Account")
        
        self.lblReason_subTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 16, text: "Please note that deleting your account does not automatically cancel your subscription. To avoid future charges, you must cancel your subscription through the App Store or Google Play Store directly. You will continue to be charged until the subscription is canceled.\n\nPlease follow the steps on your device to manage your subscription.")
        
        
        self.btn_delete.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Yes, I Understand")
        self.btn_delete.backgroundColor = .buttonBGColor
        
        DispatchQueue.main.async {
            self.updatePopupHeight(to: self.viewMain.frame.origin.x + self.viewMain.frame.size.height)
        }
        
    }
    
    
    @objc func btn_done_action() {
        self.view.endEditing(true)
    }
    
   

    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmTappped(_ sender: Any) {
        CurrentUser.shared.deleteAccount(reason: self.reason, explantion: self.explenation) { success in
            self.dismiss(animated: true)
        }
    }

}
