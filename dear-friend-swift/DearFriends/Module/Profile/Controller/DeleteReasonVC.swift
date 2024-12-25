//
//  DeleteReasonVC.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 17/10/24.
//

import UIKit

struct Reason {
    let title: String
    var isSelected: Bool
}

class DeleteReasonVC: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lbl_msgTitle: UILabel!
    @IBOutlet weak var lbl_deleteAccountTitle: UILabel!
    @IBOutlet weak var lbl_deleteAccountsubTitle: UILabel!
    @IBOutlet weak var tblReason: UITableView!
    @IBOutlet weak var txtMessage: AppCommonTextView!
    @IBOutlet weak var messageTextView: UIStackView!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_delete: AppButton!
    
    var reasons = [
            Reason(title: "I no longer use the app", isSelected: false),
            Reason(title: "The guided meditations didn’t resonate with me", isSelected: false),
            Reason(title: "I didn’t find the nature sounds/music relaxing", isSelected: false),
            Reason(title: "The voice in the meditations isn’t to my liking", isSelected: false),
            Reason(title: "I didn’t find enough variety in the content", isSelected: false),
            Reason(title: "I’m experiencing technical issues", isSelected: false),
            Reason(title: "There are too many notifications", isSelected: false),
            Reason(title: "The app’s design or interface is hard to use", isSelected: false),
            Reason(title: "The background sounds are too distracting", isSelected: false),
            Reason(title: "I prefer a different app for meditation", isSelected: false),
            Reason(title: "I think the price is too high", isSelected: false),
            Reason(title: "Other", isSelected: false)
        ]
        
        var selectedReasonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheView()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //SET THE VIEW
    func setTheView() {
        buttonImageColor(btnImage: self.btnClose, imageName: "ic_close2", colorHex: .background)
        
        //SET FONT
        self.lbl_deleteAccountTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 20, text: "Delete Account")
        self.lbl_deleteAccountsubTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "Kindly choose the reason for deleting your account.")
        self.lbl_msgTitle.configureLable(textColor: .white, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: "Message")
        
        self.btn_delete.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Delete Account")
        self.btn_delete.backgroundColor = .buttonBGColor
    }
    
    @objc func btn_done_action() {
        self.view.endEditing(true)
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.tblReason.setDefaultProperties(vc: self)
        self.tblReason.registerCell(type: DeleteReasonTVC.self)
        self.tblReason.reloadData()
        messageTextView.isHidden = true
        self.tableHeightManage()
    }

    func tableHeightManage() {
        self.tblReason.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblReason.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblReason {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.consHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func btnDeleteACTapped(_ sender: Any) {
        let vc: ConfrimDeleteVC = ConfrimDeleteVC.instantiate(appStoryboard: .Profile)
//        vc.height = 549
        vc.presentDuration = 0.3
        vc.dismissDuration = 0.3
        if reasons[selectedReasonIndex].title != "Other" {
            vc.reason = reasons[selectedReasonIndex].title
        } else if reasons[selectedReasonIndex].title == "Other", let reason = self.txtMessage.text {
            vc.reason = reason
        } else {
            GeneralUtility().showSuccessMessage(message: "Please select reason")
        }
        self.dismiss(animated: true) {
            DispatchQueue.main.async {
                if let topVc = UIApplication.topViewController2(), topVc is SettingsVC {
                    topVc.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Tableview Methods

extension DeleteReasonVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblReason.dequeueReusableCell(withIdentifier: "DeleteReasonTVC") as? DeleteReasonTVC else { return UITableViewCell() }
        let reason = reasons[indexPath.row]
        cell.btnSelect.isUserInteractionEnabled = false
        cell.btnSelect.isSelected = selectedReasonIndex == indexPath.row
        cell.lblTitle.configureLable(textColor: .background?.withAlphaComponent(0.7), fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 16, text: reason.title)
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReasonIndex = indexPath.row
        tableView.reloadData()
        
        // Show or hide the message text view if "Other" is selected
        if reasons[indexPath.row].title == "Other" {
            messageTextView.isHidden = false
        } else {
            messageTextView.isHidden = true
        }
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
