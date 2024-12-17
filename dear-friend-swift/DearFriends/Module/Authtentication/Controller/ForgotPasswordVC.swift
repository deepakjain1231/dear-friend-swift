//
//  ForgotPasswordVC.swift
//  DearFriends
//
//  Created by M1 Mac Mini 2 on 02/05/23.
//

import UIKit

class ForgotPasswordVC: BaseVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var txtEmail: AppCommonTextField!

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - VARIABLES
    
    var authVM = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setTheView()
        self.setupUI()
    }
    
    // MARK: - Other Functions
    
    func setupUI() {
        if let content = CurrentUser.shared.authContent.first(where: { $0.slug == "forgot" }) {
            GeneralUtility().setImage(imgView: self.imgView, placeHolderImage: placeholderImage, imgPath: content.image ?? "")
            self.lblTitle.text = content.title
            self.lblDescription.text = content.descriptionValue
        }
        self.changeStyle()
        self.authVM.vc = self
        self.vwScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    
    //SET THE VIEW
    func setTheView() {
    
        //SET FONT
        self.lblTitle.configureLable(textColor: .background, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "")
        self.lblDescription.configureLable(textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 16, text: "")
        
        self.lblEmailTitle.configureLable(textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Regular, fontSize: 14, text: "Email Address")
        self.txtEmail.configureText(bgColour: .clear, textColor: .background, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 14.0, text: "", placeholder: "Enter email address", keyboardType: .emailAddress)
  
        self.btnSignUp.configureLable(bgColour: .secondary, textColor: .background, fontName: GlobalConstants.RAMBLA_FONT_Bold, fontSize: 24.0, text: "Submit")

        self.btnLogin.configureLable(bgColour: .clear, textColor: .secondary_dark, fontName: GlobalConstants.OUTFIT_FONT_Medium, fontSize: 20.0, text: "Back to Login")

        //SET VIEW
        self.viewEmail.viewCorneRadius(radius: 10)
        self.viewEmail.backgroundColor = .primary
        self.viewEmail.viewBorderCorneRadius(borderColour: .secondary)
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: false)
    }
    
    @IBAction func btnSubmiTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.authVM.email = self.txtEmail.text ?? ""
        
        self.authVM.forgotPassAPI { _ in
            self.goBack(isGoingTab: false)
        } failure: { errorResponse in
            
        }
    }
}

// MARK: - Tableview Methods

// MARK: - Collection Methods

