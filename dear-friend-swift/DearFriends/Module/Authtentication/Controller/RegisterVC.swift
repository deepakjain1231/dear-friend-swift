//
//  RegisterVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit
import SKCountryPicker

class RegisterVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var stacksocial: UIStackView!
    @IBOutlet weak var vwPass: UIView!
    @IBOutlet weak var vwConfirm: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var vwMobile: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
        
    @IBOutlet weak var viewFName: UIView!
    @IBOutlet weak var lblFNameTitle: UILabel!
    @IBOutlet weak var txtFName: AppCommonTextField!

    @IBOutlet weak var viewLName: UIView!
    @IBOutlet weak var lblLNameTitle: UILabel!
    @IBOutlet weak var txtLName: AppCommonTextField!

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var txtEmail: AppCommonTextField!

    @IBOutlet weak var viewPass: UIView!
    @IBOutlet weak var lblPassTitle: UILabel!
    @IBOutlet weak var txtPass: AppCommonTextField!

    @IBOutlet weak var viewPassConf: UIView!
    @IBOutlet weak var lblPassConfTitle: UILabel!
    @IBOutlet weak var txtPassConf: AppCommonTextField!
    @IBOutlet weak var txtMobile: AppCommonTextField!

    @IBOutlet weak var lblAccept: UILabel!
    @IBOutlet weak var lblTerms: UILabel!

    @IBOutlet weak var btnLogin1: UIButton!
    @IBOutlet weak var btnLogin2: UIButton!

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblSocialTitle: UILabel!

    
    // MARK: - VARIABLES
    
    var authVM = AuthViewModel()
//    var isForSocial = false
    var backTapped: voidCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setTheView()
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        if let content = CurrentUser.shared.authContent.first(where: { $0.slug == "signup" }) {
            GeneralUtility().setImage(imgView: self.imgView, placeHolderImage: placeholderImage, imgPath: content.image ?? "")
            self.lblTitle.text = content.title
            self.lblDescription.text = content.descriptionValue
        }
//        self.authVM.isForSocial = self.isForSocial
        self.authVM.vc = self
        self.changeStyle()
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        
        self.btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        self.btnCheck.setImage(UIImage(named: "ic_checked"), for: .selected)
        
        self.txtFName.autocapitalizationType = .sentences
        self.txtLName.autocapitalizationType = .sentences
        
        if let country2 = CountryManager.shared.country(withCode: NSLocale.current.regionCode ?? "US") {
            self.lblCode.text = country2.dialingCode
            self.authVM.countryCode = country2.dialingCode ?? "+1"
            self.authVM.countryShortCode  = country2.countryCode
            self.imgFlag.image = country2.flag
            
            self.txtMobile.LeftPadding = self.vwMobile.frame.size.width + 12
            self.vwMobile.layoutIfNeeded()
        }
        
//        if self.isForSocial {
//            self.txtFName.text = self.authVM.firstName
//            self.txtLName.text = self.authVM.lastName
//            self.stacksocial.isHidden = true
//            
//            self.txtEmail.text = self.authVM.email
//            if self.authVM.email != "" {
//                self.vwEmail.alpha = 0.5
//                self.vwEmail.isUserInteractionEnabled = false
//            }
//            self.vwConfirm.isHidden = true
//            self.vwPass.isHidden = true
//        }
    }
    
    
    
    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
        self.lblDescription.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        
        self.lblFNameTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "First Name")
        self.txtFName.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter your first name", keyboardType: .emailAddress)

        self.lblLNameTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Last Name")
        self.txtLName.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter your last name", keyboardType: .emailAddress)
        
        self.lblEmailTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Email Address")
        self.txtEmail.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter email address", keyboardType: .emailAddress)
        
        self.lblPassTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Password")
        self.txtPass.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter your password", keyboardType: .emailAddress)
        
        self.lblPassConfTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Confirm Password")
        self.txtPassConf.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter your password", keyboardType: .emailAddress)
     
        self.lblAccept.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 14, text: "I read and accept all")
        self.lblTerms.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14, text: "Terms & conditions")

        self.btnLogin1.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.PLAY_FONT_Regular, fontSize: 16.0, text: "Already have an account?")
        self.btnLogin2.configureLable(bgColour: .clear, textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24.0, text: "Log In")

        self.btnSignUp.configureLable(bgColour: .secondary, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 24.0, text: "Get Started")

        self.lblSocialTitle.configureLable(textAlignment: .center, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16.0, text: "Or use social media account for log in")

        //SET VIEW
        self.viewEmail.viewCorneRadius(radius: 10)
        self.viewEmail.backgroundColor = .primary
        self.viewEmail.viewBorderCorneRadius(borderColour: .secondary)

        self.viewFName.viewCorneRadius(radius: 10)
        self.viewFName.backgroundColor = .primary
        self.viewFName.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewLName.viewCorneRadius(radius: 10)
        self.viewLName.backgroundColor = .primary
        self.viewLName.viewBorderCorneRadius(borderColour: .secondary)

        self.viewPass.viewCorneRadius(radius: 10)
        self.viewPass.backgroundColor = .primary
        self.viewPass.viewBorderCorneRadius(borderColour: .secondary)

        self.viewPassConf.viewCorneRadius(radius: 10)
        self.viewPassConf.backgroundColor = .primary
        self.viewPassConf.viewBorderCorneRadius(borderColour: .secondary)

    }
    
    
    // MARK: - Button Actions
    
    @IBAction func btnCounryCodeTapped(_ sender: UIButton) {
//        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
//            
//            guard let self = self else { return }
//            self.lblCode.text = country.dialingCode
//            self.authVM.countryCode = country.dialingCode ?? "+1"
//            self.authVM.countryShortCode  = country.countryCode
//            self.imgFlag.image = country.flag
//            
//            self.txtMobile.LeftPadding = self.vwMobile.frame.size.width + 12
//            self.vwMobile.layoutIfNeeded()
//        }
    }
    
    @IBAction func btnSocialTapped(_ sender: UIButton) {
        if !self.btnCheck.isSelected {
            GeneralUtility().showErrorMessage(message: AlertMessage.termsMissing)
        } else {
            if sender.tag == 1 {
                self.authVM.googleSignIn(isFirstTime: true)
                
            } else if sender.tag == 2 {
                self.authVM.appleSignIN(isFirstTime: true)
                
            } else if sender.tag == 3 {
                self.authVM.faceBookLogin(isFirstTime: true)
            }
        }
    }
    
    @IBAction func btnCheckTapped(_ sender: UIButton) {
        self.btnCheck.isSelected = !self.btnCheck.isSelected
    }
    
    @IBAction func btnTermsTapped(_ sender: UIButton) {
        let vc: CommonWebViewVC = CommonWebViewVC.instantiate(appStoryboard: .Profile)
        vc.hidesBottomBarWhenPushed = true
        vc.currentType = .termCondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sendOTP()
    }
    
    func sendOTP(isForResend: Bool = false) {
//        if !self.isForSocial {
            self.authVM.firstName = self.txtFName.text ?? ""
            self.authVM.lastName = self.txtLName.text ?? ""
            self.authVM.email = self.txtEmail.text ?? ""
            self.authVM.mobile = self.txtMobile.text ?? ""
            self.authVM.password = self.txtPass.text ?? ""
            self.authVM.confirmPassword = self.txtPassConf.text ?? ""
            self.authVM.isTermsAccepted = self.btnCheck.isSelected
            
            self.authVM.sendOTP { _ in
                
                if !isForResend {
                    let vc: OTPVerificationVC = OTPVerificationVC.instantiate(appStoryboard: .main)
                    vc.authVM = self.authVM
                    vc.resendTapped = {
                        self.sendOTP(isForResend: true)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } failure: { errorResponse in
                
            }
//            
//        } else {
//            self.authVM.socialParams["mobile"] = self.txtMobile.text ?? ""
//            self.authVM.socialParams["country_code"] = self.authVM.countryCode
//            self.authVM.socialParams["country_iso2_code"] = self.authVM.countryShortCode
//            self.authVM.socialParams["first_name"] = self.txtFName.text ?? ""
//            self.authVM.socialParams["last_name"] = self.txtLName.text ?? ""
//                        
//            self.authVM.firstName = self.txtFName.text ?? ""
//            self.authVM.lastName = self.txtLName.text ?? ""
//            self.authVM.email = self.txtEmail.text ?? ""
//            self.authVM.mobile = self.txtMobile.text ?? ""
//            self.authVM.isTermsAccepted = self.btnCheck.isSelected
//            self.authVM.isForSocial = true
//            self.authVM.vc = self
//            
//            if self.authVM.isValidateRegister() == false {
//                return
//            }
//            
//            self.authVM.CheckSocialAvbl(isShowErrorAlerts: true) { _ in
//                appDelegate.setTabbarRoot()
//            } failure: { errorResponse in
//                
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.authVM.vc = self
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.backTapped?()
        
        self.goBack(isGoingTab: false)
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

