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

class SubscriptionVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var vwYearLeft: UIView!
    @IBOutlet weak var vwMonthLeft: UIView!
    @IBOutlet weak var vwMonth: UIView!
    @IBOutlet weak var vwYear: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    // MARK: - VARIABLES
    
    var index = -1
    var isFromPlayer = false
    var goBack: voidCloser?
    var reloadView: voidCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTheView()
        
        self.vwYear.backgroundColor = hexStringToUIColor(hex: "#212159")
        self.vwMonth.backgroundColor = hexStringToUIColor(hex: "#212159")
        self.vwMonth.borderWidth = 0
        self.vwYear.borderWidth = 0
        self.vwMonth.borderColor = hexStringToUIColor(hex: "#776ADA")
        self.vwYear.borderColor = hexStringToUIColor(hex: "#776ADA")
        self.vwYearLeft.isHidden = false
        self.vwMonthLeft.isHidden = false
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "My Subscription")
    }
    
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
        if self.isFromPlayer {
            self.goBack?()
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        if self.index == -1 {
            GeneralUtility().showErrorMessage(message: "Please select plan to contunue")
            return
        }
        self.purchase(atomically: true, planid: appDelegate.planIDs[self.index])
    }
    
    @IBAction func btnPlanTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            self.vwYear.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.vwMonth.backgroundColor = hexStringToUIColor(hex: "#776ADA")
            self.vwYearLeft.isHidden = false
            self.vwMonthLeft.isHidden = true
            self.vwMonth.borderWidth = 1
            self.vwYear.borderWidth = 0
        } else {
            self.vwYear.backgroundColor = hexStringToUIColor(hex: "#776ADA")
            self.vwMonth.backgroundColor = hexStringToUIColor(hex: "#212159")
            self.vwYearLeft.isHidden = true
            self.vwMonthLeft.isHidden = false
            self.vwMonth.borderWidth = 0
            self.vwYear.borderWidth = 1
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
        }
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
}
