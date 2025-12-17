//
//  LoginVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 01/05/23.
//

import UIKit
import LocalAuthentication

class LoginVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var txtEmail: AppCommonTextField!

    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var lblPasswordTitle: UILabel!
    @IBOutlet weak var txtPass: AppCommonTextField!

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblRemember: UILabel!

    @IBOutlet weak var btnSignUp1: UIButton!
    @IBOutlet weak var btnSignUp2: UIButton!

    @IBOutlet weak var btnTerms1: UIButton!
    @IBOutlet weak var btnTerms2: UIButton!

    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewBiometrics: UIView!
    @IBOutlet weak var lblBiometrics: UILabel!
    @IBOutlet weak var lblSocialTitle: UILabel!
    @IBOutlet weak var btnBiometrics: AppButton!


    // MARK: - VARIABLES
    
    var authVM = AuthViewModel()
    var isSignupView : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MOVE TO SIGNUP PAGE
        if self.isSignupView {
            let vc: RegisterVC = RegisterVC.instantiate(appStoryboard: .main)
            vc.backTapped = {
                self.authVM = AuthViewModel()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
        self.restoreSavedState()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        
        let isBiometricsEnabled = UserDefaults.standard.bool(forKey: biometricsEnable)
        self.viewBiometrics.isHidden = !isBiometricsEnabled
        
        if let content = CurrentUser.shared.authContent.first(where: { $0.slug == "login" }) {
            GeneralUtility().setImage(imgView: self.imgView, placeHolderImage: placeholderImage, imgPath: content.image ?? "")
            self.lblTitle.text = content.title
            self.lblDescription.text = content.descriptionValue
        }
        
        self.changeStyle()
        self.authVM.vc = self
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        self.btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "ic_checked"), for: .selected)
        
        self.txtEmail.textContentType = .username
        self.txtPass.textContentType = .password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.isPlanPurchased = false
        self.authVM.vc = self
    }
    
    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
        self.lblDescription.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        
        self.lblEmailTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Email Address")
        self.txtEmail.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter email address", keyboardType: .emailAddress)

        self.lblPasswordTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Password")
        self.txtPass.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter your password", keyboardType: .emailAddress)

        self.lblRemember.configureLable(textColor: .secondary_light, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "Remember me")
        self.btnForgotPassword.configureLable(bgColour: .clear, textColor: .secondary_dark, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14.0, text: "Forgot password?")
        
        self.btnSignUp1.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 16.0, text: "Don’t have an account?")
        self.btnSignUp2.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24.0, text: "Sign up")

        self.btnTerms1.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14.0, text: "By proceeding, you agree to the")
        self.btnTerms2.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14.0, text: "Terms & conditions")
        
        self.btnLogin.configureLable(bgColour: .buttonBGColor, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 24.0, text: "Log In")
        self.lblBiometrics.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 18.0, text: "Use Face ID")

        self.lblSocialTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Or use social media account for log in")
        self.btnBiometrics.backgroundColor = .clear
        
        //SET VIEW
        self.viewEmail.viewCorneRadius(radius: 10)
        self.viewEmail.backgroundColor = .primary
        self.viewEmail.viewBorderCorneRadius(borderColour: .secondary)

        self.viewPassword.viewCorneRadius(radius: 10)
        self.viewPassword.backgroundColor = .primary
        self.viewPassword.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewBiometrics.viewCorneRadius(radius: 0)
        self.viewBiometrics.backgroundColor = .primary?.withAlphaComponent(0.7)
        self.viewBiometrics.viewBorderCorneRadius(borderColour: .secondary)

    }
    
    func saveStateToUserDefaults() {
        let email = self.txtEmail.text ?? ""
        let password = self.txtPass.text ?? ""
        let isChecked = self.btnCheck.isSelected
        
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "savedPassword")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "checkBoxState")
        UserDefaults.standard.synchronize()
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "savedEmail")
        defaults.set(password, forKey: "savedPassword")
        defaults.set(isChecked, forKey: "checkBoxState")
        
        // Synchronize UserDefaults to make sure the data is saved immediately
        defaults.synchronize()
        
        print("State saved to UserDefaults")
    }
    
    func restoreSavedState() {
        let defaults = UserDefaults.standard
        
        if let savedEmail = defaults.string(forKey: "savedEmail") {
            self.txtEmail.text = savedEmail
        }
        
        if let savedPassword = defaults.string(forKey: "savedPassword") {
            self.txtPass.text = savedPassword
        }
        
        if defaults.bool(forKey: "checkBoxState") {
            self.btnCheck.isSelected = true
            
        } else {
            self.btnCheck.isSelected = false
        }
        
        print("State restored from UserDefaults")
    }
    
    // MARK: - Button Actions
    @IBAction func btnTermsTapped(_ sender: UIButton) {
        let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        vc.currentType = .termCondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bntForgotTapped(_ sender: UIButton) {
        let vc: ForgotPasswordVC = ForgotPasswordVC.instantiate(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true) 
    }
    
    @IBAction func btnCheckTapped(_ sender: UIButton) {
        self.btnCheck.isSelected = !self.btnCheck.isSelected
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        let vc: RegisterVC = RegisterVC.instantiate(appStoryboard: .main)
        vc.backTapped = {
            self.authVM = AuthViewModel()
        }
//        let vc: OTPVerificationVC = OTPVerificationVC.instantiate(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSocialTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            self.authVM.googleSignIn(isFirstTime: true)
            
        } else if sender.tag == 2 {
            self.authVM.appleSignIN(isFirstTime: true)
            
        } else if sender.tag == 3 {
            self.authVM.faceBookLogin(isFirstTime: true)
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            self.SHOW_CUSTOM_LOADER()
            
            self.authVM.email = self.txtEmail.text ?? ""
            self.authVM.password = self.txtPass.text ?? ""
            
            self.authVM.loginAPI(success: { [weak self] _ in
                guard let self = self else { return }
                self.loadAudioListAndHandleBiometrics()
                
            }, failure: { errorResponse in
                // Handle login failure if needed
            })
            
        }
    }

    private func loadAudioListAndHandleBiometrics() {
        CurrentUser.shared.getBackAudioList(success: { [weak self] _ in
            guard let self = self else { return }
            if self.btnCheck.isSelected {
                self.saveStateToUserDefaults()
            }
            
            let biometricsEnabled = UserDefaults.standard.bool(forKey: biometricsEnable)
            if biometricsEnabled {
                self.HIDE_CUSTOM_LOADER()
                self.handleBiometricAuthForExistingAccount()
            } else {
                self.HIDE_CUSTOM_LOADER()
                self.promptToEnableBiometrics()
            }
        }, failure: { error in
            // Handle getBackAudioList failure if needed
        })
    }

    private func promptToEnableBiometrics() {
        let canUseBiometrics = BiometricAuthManager.shared.canUseBiometricAuthentication()
        
        let bioAlert = UIAlertController(
            title: "Enable Biometrics",
            message: "Do you want to enable biometrics authentication?",
            preferredStyle: .alert
        )
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.continueToNextScreen()
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            if canUseBiometrics {
                self.authenticateAndEnableBiometrics()
            } else {
                BiometricAuthManager.shared.showBiometricsSettingsAlert(self)
            }
        }
        
        bioAlert.addAction(noAction)
        bioAlert.addAction(yesAction)
        self.present(bioAlert, animated: true)
    }

    private func handleBiometricAuthForExistingAccount() {
        KeychainManager.shared.retrieveLoginInfo { [weak self] email, password, error in
            guard let self = self else { return }
            
            if email != self.txtEmail.text {
                self.promptToEnableBiometrics()
            } else {
                self.continueToNextScreen()
            }
        }
    }

    private func authenticateAndEnableBiometrics() {
        BiometricAuthManager.shared.authenticateWithPasscode { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                self.storeBiometricCredentials()
            }
            
            self.continueToNextScreen()
        }
    }

    private func storeBiometricCredentials() {
        KeychainManager.shared.retrieveLoginInfo { email, password, error in
            KeychainManager.shared.deleteLoginInfo(username: email ?? "", password: password ?? "")
            UserDefaults.standard.set(true, forKey: biometricsEnable)
            KeychainManager.shared.storeLoginInfo(username: self.txtEmail.text ?? "", password: self.txtPass.text ?? "")
        }
    }

    private func continueToNextScreen() {
        if let loadedString = UserDefaults.standard.string(forKey: lastPlanPurchsed) {
            appDelegate.verifyPlanReciptMain()
        } else {
            appDelegate.setTabbarRoot()
        }
    }

    @IBAction func btnBiometricsTapped(_ sender: UIButton) {
        guard BiometricAuthManager.shared.canUseBiometricAuthentication() else {
            BiometricAuthManager.shared.showBiometricsSettingsAlert(self)
            return
        }
        
        BiometricAuthManager.shared.authenticateWithPasscode { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                self.retrieveAndAutoFillCredentials()
            } else {
                self.handleAuthenticationError(error: error)
            }
        }
    }

    private func retrieveAndAutoFillCredentials() {
        KeychainManager.shared.retrieveLoginInfo { [weak self] email, password, error in
            guard let self = self else { return }
            
            if let email = email, let password = password {
                self.txtEmail.text = email
                self.txtPass.text = password
                
                self.authVM.email = email
                self.authVM.password = password
                self.authVM.loginAPI(success: { _ in
                    self.loadAudioListAndHandleBiometrics()
                }, failure: { errorResponse in
                    // Handle login failure if needed
                })
            } else if let error = error {
                GeneralUtility().showErrorMessage(message: "Login failed. Please try again.")
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleAuthenticationError(error: Error?) {
        guard let error = error as? LAError else { return }
        
        switch error.code {
        case .userCancel, .systemCancel:
            print("The user canceled the authentication")
        case .userFallback:
            BiometricAuthManager.shared.authenticateWithPasscode { [weak self] success, error in
                guard let self = self else { return }
                if success {
                    self.retrieveAndAutoFillCredentials()
                } else {
                    GeneralUtility().showErrorMessage(message: "Login failed. Please try again.")
                }
            }
        default:
            print("Authentication failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

