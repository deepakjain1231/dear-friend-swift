//
//  ScriptViewVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 24/10/23.
//

import UIKit
import WebKit

class ScriptViewVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var stackBtns: UIStackView!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwWeb: WKWebView!
    @IBOutlet weak var btnRequest: UIButton!
    
    // MARK: - VARIABLES
    
    var isFromMine = false
    var isForCompleted = false
    var isPaymentDone = false
    var chatVM = CreateCustomAudioViewModel()
    var editCountUpdate: intCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.lblTitle.text = self.chatVM.currenRequest?.meditationName ?? ""
        self.btnRequest.setTitle(   """
                                    Request Edit
                                    \(self.chatVM.currenRequest?.edit_custom_audio_request_count ?? 0)/2
                                    """, for: .normal)
        self.btnRequest.titleLabel?.numberOfLines = 2
        self.btnRequest.titleLabel?.textAlignment = .center
        self.vwWeb.layer.cornerRadius = 12
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.vwWeb.isOpaque = false
            self.vwWeb.uiDelegate = self
            self.vwWeb.navigationDelegate = self
            if let urll = URL(string: self.chatVM.currentMessage?.file ?? "") {
                let urlReq = URLRequest(url: urll)
                self.vwWeb.load(urlReq)
            }
        }
        
        if self.isForCompleted || self.isFromMine || self.isPaymentDone {
            self.stackBtns.isHidden = true
            
        } else {
            if (self.chatVM.currenRequest?.edit_custom_audio_request_count ?? 0) == 2 {
                self.btnRequest.setTitle("Cancel & Restart", for: .normal)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        CurrentUser.shared.getUserProfile(isShowLoader: true) { _ in
            
            if (CurrentUser.shared.user?.is_free_custom_audios ?? "") == "1" {
                
                var yogaVM = VideoViewModel()
                yogaVM.payForCustomChat(custom_audio_request_id: "\(self.chatVM.currenRequest?.internalIdentifier ?? 0)",
                                        total_amount: "0",
                                        payment_status: "succeed",
                                        sub_total: "0",
                                        charge: "0",
                                        isShowLoader: true) { success in
                           
                    let exists = self.navigationController?.containsViewController(ofKind: CustomAudioRequestVC.self) ?? false
                    if exists {
                        self.navigationController?.popToViewController(ofClass: CustomAudioRequestVC.self)
                    } else {
                        appDelegate.setTabbarRoot()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        GeneralUtility().showSuccessMessage(message: "Your request Approved successfully.")
                    }
                    
                } failure: { error in
                    DispatchQueue.main.async {
                        self.HIDE_CUSTOM_LOADER()
                    }
                }
                
            } else {
                let vc: YogaPaymentPageVC = YogaPaymentPageVC.instantiate(appStoryboard: .Yoga)
                vc.isForCustomAudio = true
                vc.currentCustomId = "\(self.chatVM.currenRequest?.internalIdentifier ?? 0)"
                vc.myTitle = self.chatVM.currenRequest?.meditationName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } failure: { _ in
            
        }
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        if (self.chatVM.currenRequest?.edit_custom_audio_request_count ?? 0) == 2 {
            self.deleteRequest()
            
        } else {
            self.openEditPopup()
        }
    }
    
    func deleteRequest() {
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Are you sure want to cancel and restart this request?", buttons: ["NO", "YES"]) { index in
            if index == 1 {
                self.chatVM.deleteRequest { response in
                    let exists = self.navigationController?.containsViewController(ofKind: CustomAudioRequestVC.self) ?? false
                    if exists {
                        self.navigationController?.popToViewController(ofClass: CustomAudioRequestVC.self)
                    } else {
                        appDelegate.setTabbarRoot()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        GeneralUtility().showSuccessMessage(message: "Your request cancelled successfully.")
                    }
                    
                } failure: { error in
                    
                }
            }
        }
    }
    
    func openEditPopup() {
        let popupVC: RequestEditPopupVC = RequestEditPopupVC.instantiate(appStoryboard: .CreateMusic)
        popupVC.height = 450
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.topCornerRadius = 16
        popupVC.submitText = { str in
            self.chatVM.editRequest(value: str) { response in
                
                self.chatVM.currenRequest?.edit_custom_audio_request_count = (self.chatVM.currenRequest?.edit_custom_audio_request_count ?? 0) + 1
                
                let finalCount = self.chatVM.currenRequest?.edit_custom_audio_request_count ?? 0
                self.goBack(isGoingTab: true)
                self.editCountUpdate?(finalCount)
                self.btnRequest.setTitle(   """
                                            Request Edit
                                            \(finalCount)/2
                                            """, for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                }
            } failure: { error in
                
            }
        }
        DispatchQueue.main.async {
            if let topVc = UIApplication.topViewController2() {
                topVc.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnInfoTapped(_ sender: UIButton) {
        let vc: RequestDetailsVC = RequestDetailsVC.instantiate(appStoryboard: .CreateMusic)
        vc.hidesBottomBarWhenPushed = true
        vc.chatVM = self.chatVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Tableview Methods

extension ScriptViewVC: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
    }
}


extension UINavigationController
{
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.

    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }

    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.

    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}
