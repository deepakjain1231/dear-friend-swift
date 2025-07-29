//
//  SubscriptionVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 15/05/23.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SwiftDate
import Mixpanel


protocol SubscriptionProtocol : AnyObject {
    func setTheAudio(isAudioPlay : Bool)
}

class SubscriptionVC: BaseVC {
    weak var delegate : SubscriptionProtocol? = nil

    // MARK: - OUTLETS
//    @IBOutlet weak var con_logo: NSLayoutConstraint!
    @IBOutlet weak var con_Price: NSLayoutConstraint!

    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwYearLeft: UIView!
    @IBOutlet weak var vwMonthLeft: UIView!
    @IBOutlet weak var vwMonth: UIView!
    @IBOutlet weak var vwYear: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var lbl_plan1_title: UILabel!
    @IBOutlet weak var lbl_plan2_title: UILabel!
    @IBOutlet weak var lbl_plan3_title: UILabel!
    @IBOutlet weak var lbl_plan4_title: UILabel!
    @IBOutlet weak var lbl_plan5_title: UILabel!
    @IBOutlet weak var lbl_plan6_title: UILabel!
    @IBOutlet weak var lbl_plan7_title: UILabel!

    @IBOutlet weak var lbl_plan1_subtitle: UILabel!
    @IBOutlet weak var lbl_plan2_subtitle: UILabel!
    @IBOutlet weak var lbl_plan3_subtitle: UILabel!
    @IBOutlet weak var lbl_plan4_subtitle: UILabel!
    @IBOutlet weak var lbl_plan5_subtitle: UILabel!
    @IBOutlet weak var lbl_plan6_subtitle: UILabel!
    @IBOutlet weak var lbl_plan7_subtitle: UILabel!

    @IBOutlet weak var lbl_monthly_plan: UILabel!
    @IBOutlet weak var lbl_monthly_planDetails: UILabel!
    @IBOutlet weak var lbl_monthly_plan_Price: UILabel!
    @IBOutlet weak var lbl_monthly_plan_month: UILabel!
    
    @IBOutlet weak var lbl_yearly_plan: UILabel!
    @IBOutlet weak var lbl_yearly_planDetails: UILabel!
    @IBOutlet weak var lbl_yearly_plan_Price: UILabel!
    @IBOutlet weak var lbl_yearly_plan_month: UILabel!
    @IBOutlet weak var lbl_bottom_text: UILabel!
    @IBOutlet weak var btn_Pay: UIButton!
    @IBOutlet weak var btn_Restore: UIButton!
    @IBOutlet weak var lbl_disclaimer: UILabel!
    
    // MARK: - VARIABLES
    
    var index = -1
    var isFromPlayer = false
    var goBack: voidCloser?
    var reloadView: voidCloser?
    var isAudioPlay: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTheView()
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
    }
    
    //SET THE VIEW
    func setTheView() {
        //SET
//        self.con_logo.constant = manageWidth(size: 220)
        self.con_Price.constant = manageWidth(size: 105)

        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Subscription Options")
        self.lblTitle.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20, text: "Thank you for your consideration.\n\nThe Premium plan includes the following:")
        
        self.lbl_plan1_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Ad-Free Experience")
        self.lbl_plan2_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Offline Accessibility")
        self.lbl_plan3_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Extensive Meditation Library")
        self.lbl_plan4_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Comprehensive Music Selection")
        self.lbl_plan5_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Nature Sounds Collection")
        self.lbl_plan6_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Background Audio Options")
        self.lbl_plan7_title.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 12, text: "Content Progress Bar")

        //SubTitles
        self.lbl_plan1_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Enjoy uninterrupted access to your favorite meditations, music, and nature sounds and sleep tools.")
        self.lbl_plan2_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Download and enjoy your favorite meditations and tracks anytime, anywhere.")
        self.lbl_plan3_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Explore the full  collection of over 250 guided meditations across 30+ unique categories. (This figure includes all the content in “Sleep”)")
        self.lbl_plan4_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Get full access to over 250 musical tracks, thoughtfully organized by instrument and style.")
        self.lbl_plan5_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Unlock a library of over 300 high-quality nature recordings from around the world.")
        self.lbl_plan6_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Enhance your experience with a full suite of background audio options designed to support relaxation and focus.")
        self.lbl_plan7_subtitle.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "See your progress at a glance with the Content Progress Bar. A purple line shows how far you’ve listened, while a white check mark and subtle gray line appear when the content is complete. This gentle guide helps you easily continue where you left off, and also encourages you to revisit your favorites anytime you want.")

        
        self.lbl_monthly_plan.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 16, text: "Monthly plan")
        self.lbl_monthly_planDetails.configureLable(textColor: hexStringToUIColor(hex: "FEFEFE").withAlphaComponent(0.6), fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 13, text: "Cancel anytime.")
        self.lbl_monthly_plan_month.configureLable(textColor: hexStringToUIColor(hex: "B2B1B9"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14, text: "/month")
        self.lbl_monthly_plan_Price.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 36, text: "$7.99")
        
        self.lbl_yearly_plan.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 16, text: "Yearly plan")
        self.lbl_yearly_planDetails.configureLable(textColor: hexStringToUIColor(hex: "FEFEFE").withAlphaComponent(0.6), fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 13, text: "Recommended -\nSAVE 37% off\nfrom $96 per\nyear.")
        self.lbl_yearly_planDetails.numberOfLines = 0
        self.lbl_yearly_plan_month.configureLable(textColor: hexStringToUIColor(hex: "B2B1B9"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14, text: "/year")
        self.lbl_yearly_plan_Price.configureLable(textColor: hexStringToUIColor(hex: "E4E1F8"), fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 36, text: "$59.00")
                
        self.lbl_bottom_text.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 20, text: "Access the entire app completely free for 7 days,")
        
        self.lbl_disclaimer.configureLable(textAlignment: .center, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "Disclaimer:\nThe numbers provided on this page (e.g., over 250 musical tracks, over 300 nature sounds, and over 250 meditations) are estimates and subject to change. We are constantly improving and updating our content library, which may involve adding new content, removing older content, or replacing existing material. As a result, the exact number of available tracks, sounds, and meditations may fluctuate over time. We strive to maintain a high-quality experience for our users, and these changes are part of our ongoing commitment to improvement. Thank you for your understanding.")
        
        //SET VIEW
        self.vwMonth.borderWidth = 0
        self.vwMonth.viewCorneRadius(radius: 10)
        self.vwMonthLeft.viewCorneRadius(radius: 10)
        self.vwMonth.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        self.vwMonthLeft.backgroundColor = hexStringToUIColor(hex: "#212159")
        
        self.vwYear.borderWidth = 0
        self.vwYear.viewCorneRadius(radius: 10)
        self.vwYearLeft.viewCorneRadius(radius: 10)
        self.vwYear.backgroundColor = hexStringToUIColor(hex: "#776ADA")
        self.vwYearLeft.backgroundColor = hexStringToUIColor(hex: "#212159")
        
        self.btn_Pay.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Subscribe Now")
        self.btn_Pay.backgroundColor = .buttonBGColor
        
        
        self.btn_Restore.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 18.0, text: "Restore Purchases")
    }
    
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
        if self.isFromPlayer {
            self.delegate?.setTheAudio(isAudioPlay: self.isAudioPlay)
            self.goBack?()
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        if self.index == -1 {
            GeneralUtility().showErrorMessage(message: "Please select plan to continue")
            return
        }
        
        Mixpanel.mainInstance().track(event: Mixpanel_Event.UpgradePremium.rawValue, properties: nil)

        self.purchase(atomically: true, planid: appDelegate.planIDs[self.index])
    }
    
    @IBAction func btnPlanTapped(_ sender: UIButton) {
        self.setTheView()
        
        if sender.tag == 0 {
            self.vwMonth.backgroundColor = hexStringToUIColor(hex: "#363C8A").withAlphaComponent(0.7)
            self.vwMonthLeft.backgroundColor = .clear
            self.vwMonth.borderWidth = 1
            self.vwMonth.layer.borderColor = UIColor(named: "secondary")?.cgColor
        } else {
            self.vwYear.backgroundColor = hexStringToUIColor(hex: "#363C8A")
            self.vwYearLeft.backgroundColor = .clear
            self.vwYear.borderWidth = 1
            self.vwYear.layer.borderColor = UIColor(named: "secondary")?.cgColor
        }
        self.index = sender.tag
    }
    
    @IBAction func btnRestoreTapped(_ sender: UIButton) {
        SHOW_CUSTOM_LOADER()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.HIDE_CUSTOM_LOADER()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                if let first = results.restoredPurchases.first {
                    appDelegate.planRestore(param: ["transaction_id": first.originalTransaction?.transactionIdentifier ?? ""])
                }
            }
            else {
                print("Nothing to Restore")
                GeneralUtility().showErrorMessage(message: "Nothing to Restore")
            }
        }
    }
}

//MARK: - IN APP PURCHASE FUNCTIONS

extension SubscriptionVC {
    
    func purchase(atomically: Bool, planid : String) {

        SHOW_CUSTOM_LOADER()
        SwiftyStoreKit.purchaseProduct(planid, atomically: atomically) { result in
            self.HIDE_CUSTOM_LOADER()

            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    //self.verifySubscriptions([.Plan1Monthly, .Plan2Quarterly, .Plan3HalfYearly, .Plan4Yearly])
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    func planPurchase(param: [String: Any]) {
        
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            
            //self.verifySubscriptions([.Plan1Monthly, .Plan2Quarterly, .Plan3HalfYearly, .Plan4Yearly])
            appDelegate.verifyPlanRecipt(productId: purchase.productId,
                                         transactionId: purchase.transaction.transactionIdentifier ?? "",
                                         isShowLoader: true) { succes in
                if succes {
                    self.reloadView?()
                }
            }
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        @unknown default:
            return nil

        }
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
}
