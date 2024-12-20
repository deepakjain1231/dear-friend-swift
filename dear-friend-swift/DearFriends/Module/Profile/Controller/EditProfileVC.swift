//
//  EditProfileVC.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 13/05/23.
//

import UIKit
import SKCountryPicker

class EditProfileVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
    @IBOutlet weak var txtLName: AppCommonTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtMobile: AppCommonTextField!
    @IBOutlet weak var vwMobile: UIView!
    @IBOutlet weak var txtFName: AppCommonTextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn_Save: AppButton!
    
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewMobile: UIView!
    
    @IBOutlet weak var lblFirstNameTitle: UILabel!
    @IBOutlet weak var lblLastNameTitle: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblMobileTitle: UILabel!
    
    // MARK: - VARIABLES
    
    var authVM = AuthViewModel()
    var edited: voidCloser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
    }
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Edit Profile")
        
        self.lblFirstNameTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "First name")
        self.lblLastNameTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Last name")
        self.lblEmailTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Edit Email")
        self.lblMobileTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 12, text: "Phone Number")
        self.lblCode.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14, text: "+91")
        
        self.txtFName.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14.0, text: "", placeholder: "Enter your first name", keyboardType: .default)
        self.txtLName.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14.0, text: "", placeholder: "Enter your last name", keyboardType: .default)
        self.txtEmail.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14.0, text: "", placeholder: "Enter your email", keyboardType: .emailAddress)
        self.txtMobile.configureText(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 14.0, text: "", placeholder: "Enter mobile number", keyboardType: .phonePad)
        
        self.btn_Save.configureLable(bgColour: .clear, textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 20.0, text: "Save")
        
        self.txtFName.LeftPadding = 0
        self.txtLName.LeftPadding = 0
        self.txtEmail.LeftPadding = 0
        
        //SET VIEW
        self.viewFirstName.viewCorneRadius(radius: 15)
        self.viewFirstName.backgroundColor = .primary?.withAlphaComponent(0.8)
        self.viewFirstName.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewLastName.viewCorneRadius(radius: 15)
        self.viewLastName.backgroundColor = .primary?.withAlphaComponent(0.8)
        self.viewLastName.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewEmail.viewCorneRadius(radius: 15)
        self.viewEmail.backgroundColor = .primary?.withAlphaComponent(0.8)
        self.viewEmail.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewMobile.viewCorneRadius(radius: 15)
        self.viewMobile.backgroundColor = .primary?.withAlphaComponent(0.8)
        self.viewMobile.viewBorderCorneRadius(borderColour: .secondary)
        
        self.btn_Save.backgroundColor = .buttonBGColor
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        self.authVM.vc = self
        self.changeStyle()
             
        if let country2 = CountryManager.shared.country(withCode: CurrentUser.shared.user?.countryIso2Code ?? "") {
            
            self.imgFlag.image = country2.flag
            self.lblCode.text = country2.dialingCode
            self.authVM.countryCode = country2.dialingCode ?? "+1"
            self.authVM.countryShortCode  = country2.countryCode
            
            self.txtMobile.LeftPadding = self.vwMobile.frame.size.width
            self.vwMobile.layoutIfNeeded()
        }
        
        self.txtFName.text = CurrentUser.shared.user?.firstName ?? ""
        self.txtLName.text = CurrentUser.shared.user?.lastName ?? ""
        self.txtEmail.text = CurrentUser.shared.user?.email ?? ""
        self.txtMobile.text = CurrentUser.shared.user?.mobile ?? ""
        
        GeneralUtility().setImage(imgView: self.imgProfile, placeHolderImage: placeholderImage, imgPath: CurrentUser.shared.user?.profileImage ?? "")
        
        if CurrentUser.shared.user?.is_social == "1" {
            self.viewEmail.alpha = 0.5
            self.viewEmail.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnChangeProfile(_ sender: UIButton) {
        ImagePickerManager().pickImage(self, sourceType: .both) { img in
            self.imgProfile.image = img
            self.authVM.profileImgData = (self.imgProfile.image?.jpegData(compressionQuality: 0.8))
        }
    }
    
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
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.sendOTP()
    }
    
    func sendOTP(isForResend: Bool = false) {
        
        self.authVM.firstName = self.txtFName.text ?? ""
        self.authVM.lastName = self.txtLName.text ?? ""
        self.authVM.email = self.txtEmail.text ?? ""
        self.authVM.mobile = self.txtMobile.text ?? ""
        
        if self.authVM.email != (CurrentUser.shared.user?.email ?? "") {
            self.authVM.sendOTP(type: "update") { _ in
                if !isForResend {
                    let vc: OTPVerificationVC = OTPVerificationVC.instantiate(appStoryboard: .main)
                    vc.authVM = self.authVM
                    vc.isForEditProfile = true
                    vc.resendTapped = {
                        self.sendOTP(isForResend: true)
                    }
                    self.edited?()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } failure: { errorResponse in
                
            }
        } else {
            self.authVM.profileImgData = (self.imgProfile.image?.jpegData(compressionQuality: 0.8))
            self.authVM.editProfileAPI { _ in
                self.edited?()
                self.goBack(isGoingTab: true)
            } failure: { errorResponse in
                
            }
        }
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods
