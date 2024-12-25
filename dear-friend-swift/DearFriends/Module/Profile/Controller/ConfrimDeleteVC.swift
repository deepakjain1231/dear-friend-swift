//
//  ConfrimDeleteVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 17/10/24.
//

import UIKit
import BottomPopup

class ConfrimDeleteVC: BottomPopupViewController {

    @IBOutlet weak var lbl_ConfirmDeleteTitle: UILabel!
    @IBOutlet weak var lbl_ConfirmDeletesubTitle: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblReason_subTitle: UILabel!
    @IBOutlet weak var txtExplenation: AppCommonTextView!
    @IBOutlet weak var txtPlaceholderExplenation: UITextView!
    @IBOutlet weak var btn_delete: AppButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnClose: UIButton!

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
    
    var reason = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        buttonImageColor(btnImage: self.btnClose, imageName: "ic_close2", colorHex: .background)

//        self.txtExplenation.iq_addDone(target: self, action: #selector(self.btn_done_action), title: "Brief explanation...")

        self.txtPlaceholderExplenation.configureText(bgColour: .clear, textColor: UIColor.background ?? UIColor.white, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "Brief explanation...")
        self.txtExplenation.configureText(bgColour: .clear, textColor: UIColor.background ?? UIColor.white, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "")
        self.txtExplenation.delegate = self

        
        //SET FONT
        self.lbl_ConfirmDeleteTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 20, text: "Confirm Delete")
        self.lbl_ConfirmDeletesubTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Confirm to Permanently Delete Your Account")
        
        self.lblReason.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "")
        self.lblReason_subTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 16, text: "Please take a moment to share a bit more about your decision. Your feedback helps us improve and create a better experience for everyone.")
        
        
        self.btn_delete.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Confirm Delete")
        self.btn_delete.backgroundColor = .buttonBGColor
        
        self.updatePopupHeight(to: self.viewMain.frame.origin.x + self.viewMain.frame.size.height)
    }
    
    
    @objc func btn_done_action() {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.lblReason.text = reason
    }

    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnConfirmTappped(_ sender: Any) {
        let vc: SubsciptionDeleteVC = SubsciptionDeleteVC.instantiate(appStoryboard: .Profile)
//        vc.height = 549
        vc.presentDuration = 0.3
        vc.dismissDuration = 0.3
        vc.reason = self.reason
        vc.explenation = self.txtExplenation.text
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                if let topVc = UIApplication.topViewController2(), topVc is SettingsVC {
                    topVc.present(vc, animated: true, completion: nil)
                }
            }
        }
        
//        CurrentUser.shared.deleteAccount(reason: self.reason, explantion: self.txtExplenation.text ?? "") { success in
//            self.dismiss(animated: true)
//        }
    }

}


extension ConfrimDeleteVC: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newText.count != 0{
            self.txtPlaceholderExplenation.text = ""
        }
        else{
            self.txtPlaceholderExplenation.text = "Brief explanation..."
            self.txtExplenation.text = ""
        }
     
        return true
        
    }
    
}
