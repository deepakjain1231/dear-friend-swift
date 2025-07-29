//
//  OTPVerificationVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit

class OTPVerificationVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vwScroll: UIScrollView!
//    @IBOutlet var otpTextFieldView: OTPFieldView!
    @IBOutlet var otpTextFields: [OTPTextField]!
    @IBOutlet var viewOTP: [UIView]!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnResend1: UIButton!
    @IBOutlet weak var btnResend2: UIButton!
    
    // MARK: - VARIABLES
    
    var authVM = AuthViewModel()
    var isForEditProfile = false
    var resendTapped: voidCloser?
    var selectTag : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard(true)
        
        // Do any additional setup after loading the view.
        self.setTheView()
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        if let content = CurrentUser.shared.authContent.first(where: { $0.slug == "otp" }) {
            GeneralUtility().setImage(imgView: self.imgView, placeHolderImage: placeholderImage, imgPath: content.image ?? "")
            self.lblTitle.text = content.title
            self.lblDescription.text = content.descriptionValue
        }
        self.changeStyle()
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
//        self.setupOtpView()
        self.lblEmail.isHidden = false
        
        GeneralUtility().changeTextColor(substring: self.authVM.email, string: "Enter 6-Digit code we just sent at your email address \(self.authVM.email)", foregroundColor: hexStringToUIColor(hex: "#E4E1F8"), label: self.lblEmail)
    }
    
    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
        self.lblDescription.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        
  
        self.btnConfirm.configureLable(bgColour: .secondary, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 24.0, text: "Confirm")

        self.btnResend1.configureLable(bgColour: .clear, textColor: .secondary_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Didn’t get the code?")
        self.btnResend2.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Resend Code")

        //SET VIEW AND TEXT
        self.setupTextFields()
        self.setupViewOTP()
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        self.view.endEditing(true)
//        self.otpTextFieldView.initializeUI()
        self.authVM.otp = ""
        self.resendTapped?()
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.authVM.otp = ""
        self.goBack(isGoingTab: false)
    }
    
    @IBAction func btnSubmiTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.verifyOTP()
    }
    
    func verifyOTP() {
        self.authVM.otp = getCode()

        guard !self.authVM.otp.isEmpty else {
            GeneralUtility().showErrorMessage(message: "Please enter OTP")
            return
        }
        
        guard self.authVM.otp.count == 6 else {
            GeneralUtility().showErrorMessage(message: "Please enter 6 digit valid OTP")
            return
        }
        
        if self.isForEditProfile {
            self.authVM.editProfileAPI { _ in
                self.navigationController?.popToRootViewController(animated: true)
            } failure: { errorResponse in
                // Handle error (if needed)
            }
        } else {
            self.authVM.registerAPI { _ in
                CurrentUser.shared.getBackAudioList { _ in
                    UserDefaults.standard.set(nil, forKey: intro_showcase_1_completed)
                    UserDefaults.standard.set(nil, forKey: intro_showcase_1_SkippedDate)
                    UserDefaults.standard.set(nil, forKey: intro_showcase_2_completed)
                    UserDefaults.standard.set(nil, forKey: intro_showcase_2_SkippedDate)
                    UserDefaults.standard.set(nil, forKey: userRatedApp)
                    UserDefaults.standard.set(nil, forKey: lastPromptKey)
                    UserDefaults.standard.set(nil, forKey: maxPromptCountKey)
                    UserDefaults.standard.set(nil, forKey: lastPreferenceDate)
                    
                    self.presentBiometricAlert()
                } failure: { errorResponse in
                    // Handle error (if needed)
                }
            } failure: { errorResponse in
                // Handle error (if needed)
            }
        }
    }

    // Helper function to present biometric alert
    private func presentBiometricAlert() {
        let biometricManager = BiometricAuthManager.shared
        let canUseBiometrics = biometricManager.canUseBiometricAuthentication()
        
        let bioAlert = UIAlertController(title: "Enable Biometrics", message: "Do you want to enable biometrics authentication?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.navigateToNextScreen()
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.handleBiometricAuthentication(canUseBiometrics: canUseBiometrics)
        }
        
        bioAlert.addAction(noAction)
        bioAlert.addAction(yesAction)
        self.present(bioAlert, animated: true)
    }

    // Helper function to handle biometric authentication
    private func handleBiometricAuthentication(canUseBiometrics: Bool) {
        if canUseBiometrics {
            BiometricAuthManager.shared.authenticateWithPasscode { success, error in
                if success {
                    KeychainManager.shared.retrieveLoginInfo { email, password, error in
                        if let email = email, let password = password {
                            KeychainManager.shared.deleteLoginInfo(username: email, password: password)
                            print("Biometric authentication successful")
                        }
                        UserDefaults.standard.set(true, forKey: biometricsEnable)
                        KeychainManager.shared.storeLoginInfo(username: self.authVM.email, password: self.authVM.password)
                    }
                } else {
                    print("Biometric authentication was canceled or failed")
                }
                self.navigateToNextScreen()
            }
        } else {
            BiometricAuthManager.shared.showBiometricsSettingsAlert(self)
        }
    }

    // Helper function to navigate to the next screen based on subscription
    private func navigateToNextScreen() {
        if let loadedString = UserDefaults.standard.string(forKey: lastPlanPurchsed) {
            appDelegate.verifyPlanReciptMain()
        } else {
            appDelegate.setTabbarRoot()
        }
    }
}

// MARK: - OTP Methods

//extension OTPVerificationVC: OTPFieldViewDelegate {
//    
//    func setupOtpView() {
//        self.otpTextFieldView.fieldsCount = 6
//        self.otpTextFieldView.fieldBorderWidth = 1
//        self.otpTextFieldView.defaultBorderColor = UIColor.clear
//        self.otpTextFieldView.filledBorderColor = hexStringToUIColor(hex: "#776ADA")
//        self.otpTextFieldView.cursorColor = UIColor.white
//        self.otpTextFieldView.filledBackgroundColor = hexStringToUIColor(hex: "#363C8A")
//        self.otpTextFieldView.defaultBackgroundColor = hexStringToUIColor(hex: "#212159")
//        self.otpTextFieldView.displayType = .circular
//        self.otpTextFieldView.fieldSize = (self.view.frame.size.width - 70) / 6
//        self.consHieght.constant = (self.view.frame.size.width - 70) / 6
//        self.otpTextFieldView.separatorSpace = 6
//        self.otpTextFieldView.shouldAllowIntermediateEditing = false
//        self.otpTextFieldView.delegate = self
//        self.otpTextFieldView.initializeUI()
//        self.view.layoutIfNeeded()
//    }
//    
//    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
//        if hasEntered {
//            self.view.endEditing(true)
//            self.otpTextFieldView.endEditing(true)
//            self.verifyOTP()
//        }
//        print("Has entered all OTP? \(hasEntered)")
//        return false
//    }
//    
//    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
//        return true
//    }
//    
//    func enteredOTP(otp otpString: String) {
//        print("OTPString: \(otpString)")
//        self.authVM.otp = otpString
//    }
//}






extension OTPVerificationVC: UITextFieldDelegate, OTPTextFieldDelegate{
    //................... OTHER FUNCTION ............//
    // MARK: - SET TEXT VIEW
    func setupTextFields() {
        for (index, textField) in otpTextFields.enumerated() {
            textField.text = ""
          
            textField.tintColor = UIColor.black
            
            textField.configureText(textAlignment: .center ,bgColour: .clear, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 18.0, text: "", placeholder: "", keyboardType: .numberPad)
            textField.codeDelegate = self
            textField.delegate = self
            if index == 0 {
                textField.text = ""
                textField.becomeFirstResponder()
            }
        }
    }

    func setupViewOTP() {
        for view in viewOTP{
            view.viewCorneRadius(radius: 10)
            view.backgroundColor = .primary
            view.viewBorderCorneRadius(borderColour: .secondary)
        }
    }
    
    
    
    //GET THE CODE
    func getCode() -> String {
        var code = ""
        for textField in otpTextFields {
            if let text = textField.text {
                code.append(text)
            }
        }
        return code
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        if isCodeNumeric(string){
            if string.count != 1{
                let arrOTP = string.map { String($0) }
                for i in 0..<arrOTP.count{
                    self.otpTextFields[i].text = arrOTP[i]
                    otpTextFields[i].becomeFirstResponder()
                    self.selectTag = i
                }
            }
            else{
                textField.text = string
                if textField.tag < otpTextFields.count-1 {
                    otpTextFields[textField.tag+1].becomeFirstResponder()
                    self.selectTag = self.selectTag + 1

                } else {
                    view.endEditing(true)
                    self.selectTag = textField.tag

                    
                    //CHECK OTP VALIDATION
                    self.verifyOTP()
                }
            }
            
           
        }
        else{
            otpTextFields[self.selectTag].text = ""
            self.selectTag = self.selectTag - 1
            if self.selectTag <= 0{
                self.selectTag = 0
            }
            otpTextFields[self.selectTag].becomeFirstResponder()
        }
        return false
    }
    
    
    
    func codeTextFieldDidDeleteBackward(_ textField: OTPTextField) {
        if textField.text == "" && textField.tag > 0 {
            print("===?>\(self.selectTag))")

            otpTextFields[self.selectTag].becomeFirstResponder()
            otpTextFields[self.selectTag].text = ""
            self.selectTag = self.selectTag - 1
            if self.selectTag <= 0{
                self.selectTag = 0
            }
        }
    }
    
    func isCodeNumeric(_ code : String) -> Bool {
        if code.isNumber {
            if code.count != 1{
                if code.count == 6{
                    return true
                }
                else{
                    return false
                }
            }
            return true
        }
        return false
    }
}


