//
//  YogaPaymentPageVC.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/09/23.
//

import UIKit
import Stripe

class YogaPaymentPageVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblBottomDecro: UILabel!
    @IBOutlet weak var txtCVV: AppCommonTextField!
    @IBOutlet weak var txtDate: AppCommonTextField!
    @IBOutlet weak var txtNumber: AppCommonTextField!
    @IBOutlet weak var txtCardName: AppCommonTextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    // MARK: - VARIABLES
    
    var yogaVM = VideoViewModel()
    
    var isForCustomAudio = false
    var currentCustomId = ""
    var myTitle = ""
    
    var customVM = CreateCustomAudioViewModel()
    var isForMyOwn = false
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.yogaVM.vc = self
        if self.isForCustomAudio {
            let price = Double(appDelegate.finalAmountMain)?.roundedValues(toPlaces: 2) ?? 0
            self.lblPrice.text = "\(smallAppCurrency)\(String(format: "%.2f", price))"
            self.yogaVM.pay_amount = appDelegate.finalAmountMain
            self.lblBottomDecro.text = "Exclusive Launch Offer: For the exclusive price of $\(appDelegate.finalAmountMain), your package includes the following:  - A dedicated scriptwriting assistant with extensive writing experience. - A personalized recording that you will own, edited and recorded by a pro."
            
        } else {
            let price = Double(self.yogaVM.currentInstructorDetails?.session_price ?? "")?.roundedValues(toPlaces: 2) ?? 0
            self.lblPrice.text = "\(smallAppCurrency)\(String(format: "%.2f", price))"
            self.yogaVM.pay_amount = self.yogaVM.currentInstructorDetails?.session_price ?? ""
        }
        self.btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "ic_checked"), for: .selected)
        
        self.txtNumber.delegate = self
        self.txtCVV.delegate = self
        self.txtCVV.isSecureTextEntry = true
        self.txtDate.delegate = self
        self.txtCardName.keyboardType = .default
        self.txtCardName.autocapitalizationType = .sentences
        self.txtNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        self.txtNumber.addTarget(self, action: #selector(self.editingEnd(_:)), for: .editingDidEnd)
        self.txtNumber.addTarget(self, action: #selector(self.editingStart(_:)), for: .editingDidBegin)
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnTermsTapped(_ sender: UIButton) {
        let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        if self.isForCustomAudio {
            vc.currentType = .user_agreement_create_section
        } else {
            vc.currentType = .user_agreement_booking
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editingStart(_ textField: UITextField) {
        self.txtNumber.rightImage = UIImage()
    }
    
    @objc func editingEnd(_ textField: UITextField) {
        if self.txtNumber.text != "" {
            
            if self.yogaVM.checkCardNumberisValid(cardNumber: textField.text ?? "") {
                self.txtNumber.rightImage = UIImage(named: "ic_verified")
                
            } else {
                self.txtNumber.rightImage = UIImage(named: "ic_notverified")
            }
        }
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.yogaVM.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.yogaVM.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnCheckTapped(_ sender: UIButton) {
        self.btnCheck.isSelected = !self.btnCheck.isSelected
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.txtCardName.text == "" {
            GeneralUtility().showErrorMessage(message: "Please enter card holder name")
            return
            
        } else if self.txtNumber.text == "" {
            GeneralUtility().showErrorMessage(message: "Please enter card number")
            return
            
        } else if self.txtDate.text == "" {
            GeneralUtility().showErrorMessage(message: "Please enter card expiry date and month")
            return
            
        } else if self.txtCVV.text == "" {
            GeneralUtility().showErrorMessage(message: "Please enter card cvv")
            return
            
        } else if self.btnCheck.isSelected == false {
            GeneralUtility().showErrorMessage(message: "Please accept terms and conditions")
            return
        }
        
        var finalAmount = self.yogaVM.currentInstructorDetails?.session_price ?? ""
        if self.isForCustomAudio {
            finalAmount = appDelegate.finalAmountMain
        }
        
        DispatchQueue.main.async {
            self.SHOW_CUSTOM_LOADER()
        }
        
        self.yogaVM.createPaymentIntent(amount: finalAmount) { reponse in
            
            self.pay { success in
                if success {
                    if self.isForCustomAudio {
                        if self.isForMyOwn {
                            self.customVM.total_amount = finalAmount
                            self.customVM.sub_total = finalAmount
                            self.customVM.transaction_id = self.yogaVM.txnID
                            self.customVM.currency = "USD"
                            
                            self.customVM.createCustomRequest(isShowLoader: false) { repose in
                                
                                DispatchQueue.main.async {
                                    self.HIDE_CUSTOM_LOADER()
                                }
                                
                                let vc: SuccessfullBookingVC = SuccessfullBookingVC.instantiate(appStoryboard: .MyBookings)
                                vc.isForCustomChat = true
                                vc.myTitle = self.myTitle
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            } failure: { errorResponse in
                                
                            }
                            
                        } else {
                            self.yogaVM.payForCustomChat(custom_audio_request_id: self.currentCustomId,
                                                         total_amount: finalAmount,
                                                         payment_status: "succeed",
                                                         sub_total: finalAmount,
                                                         charge: "0") { success in
                                
                                DispatchQueue.main.async {
                                    self.HIDE_CUSTOM_LOADER()
                                }
                                
                                let vc: SuccessfullBookingVC = SuccessfullBookingVC.instantiate(appStoryboard: .MyBookings)
                                vc.isForCustomChat = true
                                vc.myTitle = self.myTitle
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            } failure: { error in
                                DispatchQueue.main.async {
                                    self.HIDE_CUSTOM_LOADER()
                                }
                            }
                        }
                        
                    } else {
                        self.yogaVM.bookVideo { _ in
                            
                            DispatchQueue.main.async {
                                self.HIDE_CUSTOM_LOADER()
                            }
                            
                            let vc: SuccessfullBookingVC = SuccessfullBookingVC.instantiate(appStoryboard: .MyBookings)
                            vc.isFromYoga = true
                            vc.yogaVM = self.yogaVM
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } failure: { errorResponse in
                            DispatchQueue.main.async {
                                self.HIDE_CUSTOM_LOADER()
                            }
                        }
                    }
                }
            }
            
        } failure: { errorResponse in
            
        }
    }
    
    @IBAction func btnPaymentTapped(_ sender: UIButton) {
        let popupVC: PaymentDetailsPopupVC = PaymentDetailsPopupVC.instantiate(appStoryboard: .Yoga)
        popupVC.height = 250
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        var finalAmount = self.yogaVM.currentInstructorDetails?.session_price ?? ""
        if self.isForCustomAudio {
            finalAmount = appDelegate.finalAmountMain
        }
        popupVC.finalAmountMain = finalAmount
        DispatchQueue.main.async {
            if let topVc = UIApplication.topViewController2() {
                topVc.present(popupVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView Methods

// MARK: - CollectionView Methods

// MARK: - Textfield

extension YogaPaymentPageVC: UITextFieldDelegate {
    
    func expDateValidation(dateStr:String) {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
            } else {
                print("Entered Date Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                   print("Entered Date Is Right")
                } else {
                   print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else {
           print("Entered Date Is Wrong")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtNumber {
            
            if self.txtNumber.text != "" {
                if self.yogaVM.checkCardNumberisValid(cardNumber: textField.text ?? "") {
                    self.txtNumber.rightImage = UIImage(named: "ic_verified")
                    self.yogaVM.stripeparams.number = textField.text ?? ""
                    
                } else {
                    self.txtNumber.rightImage = UIImage(named: "ic_notverified")
                }
            }
            
        } else if textField == self.txtDate {
            
            if self.txtDate.text != "" {
                let str: String = self.txtDate.text ?? ""
                let array: NSArray = str.components(separatedBy: "/") as NSArray
                var str_mon: String = ""
                var str_year: String = ""
                
                if array.count == 2 {
                    str_mon = array.object(at: 0) as? String ?? ""
                    str_year = array.object(at: 1) as? String ?? ""
                    
                } else {
                    print("invalid expiry date")
                    GeneralUtility().showErrorMessage(message: "Invalid expiry date. Expiry date format is MM/yy")
                    return
                }
                
                if str_year == "" || str_mon == "" {
                    GeneralUtility().showErrorMessage(message: "Invalid expiry date. Expiry date format is MM/yy")
                    
                } else {
                    if self.yogaVM.checkCardExpDateisValid(expMonth: str_mon, andExpirationYear: str_year) {
                        self.yogaVM.stripeparams.expMonth = UInt(str_mon) ?? 0
                        self.yogaVM.stripeparams.expYear = UInt(str_year) ?? 0
                    }
                }
            }
            
        } else if textField == self.txtCVV {
            
            if self.txtCVV.text != "" {
                if self.yogaVM.checkCardCVVisValid(cvc: self.txtCVV.text ?? "") {
                    self.yogaVM.stripeparams.cvc = self.txtCVV.text ?? ""
                }
            }
            
        } else if textField == self.txtCardName {
            
            if self.txtCardName.text != "" {
                self.yogaVM.stripeparams.name = self.txtCardName.text ?? ""
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        
        if textField == self.txtCVV {
            let charsLimit = 4
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            return newLength <= charsLimit
            
        } else if textField == self.txtDate {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)
            
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
                
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
                
            } else if updatedText.count == 2 {
                if updatedText <= "12" { //Prevent user to not enter month more than 12
                    textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                }
                return false
                
            } else if updatedText.count == 5 {
                self.expDateValidation(dateStr: updatedText)
                
            } else if updatedText.count > 5 {
                return false
            }
            
            return true
        }
        return true
    }
}

extension YogaPaymentPageVC: STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    func pay(success: @escaping (Bool) -> Void) {
        
        self.SHOW_CUSTOM_LOADER()
        
        guard let paymentIntentClientSecret = self.yogaVM.paymentIntentClientSecret else {
            return
        }
        
        // Collect card details
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = self.yogaVM.stripeparams.number ?? ""
        cardParams.cvc = self.yogaVM.stripeparams.cvc ?? ""
        cardParams.expMonth = NSNumber(value: self.yogaVM.stripeparams.expMonth)
        cardParams.expYear = NSNumber(value: self.yogaVM.stripeparams.expYear)
        
        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.name = self.yogaVM.stripeparams.name ?? ""
        
        let paymentMethodParams =  STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        paymentIntentParams.receiptEmail = CurrentUser.shared.user?.email ?? ""
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                showAlertWithTitleFromVC(vc: self, title: "Payment failed", andMessage: error?.localizedDescription ?? "", buttons: ["OKAY"]) { btn in
                }
                self.HIDE_CUSTOM_LOADER()
                success(false)
                break
            case .canceled:
                showAlertWithTitleFromVC(vc: self, title: "Payment canceled", andMessage: error?.localizedDescription ?? "", buttons: ["OKAY"]) { btn in
                }
                self.HIDE_CUSTOM_LOADER()
                success(false)
                break
            case .succeeded:
                GeneralUtility().showSuccessMessage(message: "Payment Processed Successfully")
                success(true)
                break
            @unknown default:
                self.HIDE_CUSTOM_LOADER()
                break
            }
        }
    }
}
