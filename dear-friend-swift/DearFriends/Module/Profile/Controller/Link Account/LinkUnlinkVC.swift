//
//  LinkUnlinkVC.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 04/12/24.
//

import UIKit
import GoogleSignIn
import SwiftyJSON
//import FacebookCore
//import FacebookLogin

class LinkUnlinkVC: BaseVC {
    
    // MARK: - OUTLETS
    
    
    @IBOutlet weak var lblGamilLink: UILabel!
    @IBOutlet weak var lblAppleLink: UILabel!
    @IBOutlet weak var lblFBLink: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var viewGmail: UIView!
    @IBOutlet weak var viewApple: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var lblGamilTitle: UILabel!
    @IBOutlet weak var lblAppleTitle: UILabel!
    @IBOutlet weak var lblFBTitle: UILabel!
    
    
    var authVM = AuthViewModel()
    var socialParams = [String: Any]()
    private let appleSignIn = HSAppleSignIn()

    var isGoogle : Bool = false
    var isApple : Bool = false
    var isFB : Bool = false
    
    // MARK: - VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setTheView()
        self.changeStyle()
        self.getLinkDate()
    }
    
    
    //SET THE VIEW
    func setTheView() {
        
        //SET FONT
        self.lblNavTitle.configureLable(textColor: .white, fontName: GlobalConstants.PLAY_FONT_Bold, fontSize: 24, text: "Link/Unlink Account")
        
        self.lblGamilTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "Gmail")
        self.lblAppleTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "Apple")
        self.lblFBTitle.configureLable(textColor: .white, fontName: GlobalConstants.RAMBLA_FONT_Regular, fontSize: 15, text: "Facebook")
        
        //SET VIEW
        self.viewGmail.viewCorneRadius(radius: 10)
        self.viewGmail.backgroundColor = .primary
        self.viewGmail.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewApple.viewCorneRadius(radius: 10)
        self.viewApple.backgroundColor = .primary
        self.viewApple.viewBorderCorneRadius(borderColour: .secondary)
        
        self.viewFacebook.viewCorneRadius(radius: 10)
        self.viewFacebook.backgroundColor = .primary
        self.viewFacebook.viewBorderCorneRadius(borderColour: .secondary)
        self.viewFacebook.isHidden = true
        
        let isApplePrivateEmailAddress = CurrentUser.shared.user?.email?.hasSuffix("@privaterelay.appleid.com")
        if isApplePrivateEmailAddress == true{
            self.viewApple.isHidden = true
        }

    }
    
    
    func getLinkDate(){
        self.getSocialList { response in
            print(response)
        } failure: { error in
            GeneralUtility.sharedInstance.showErrorMessage(message: "\(error["message"])")
        }
    }
    // MARK: - Other Functions
    
    // MARK: - Button Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.goBack(isGoingTab: true)
    }
    
    @IBAction func btnMenuTaped(_ sender: UIButton) {
        
        if sender.tag == 1{
            if self.isGoogle{
                self.userUnlink(sender: sender, type: "Google")
            }
            else{
                self.googleSignIn(isFirstTime: true)
            }
        }
        else if sender.tag == 2{
            if self.isApple{
                self.userUnlink(sender: sender, type: "Apple")
            }
            else{
                self.appleSignIN(isFirstTime: true)
            }
        }
        else if sender.tag == 3{
            if self.isFB{
                self.userUnlink(sender: sender, type: "Facebook")
            }
            else{
                self.faceBookLogin(isFirstTime: true)
            }
        }
    
    }
    
    
    func userUnlink(sender: UIButton, type : String){
        
        let popupVC: CommonBottomPopupVC = CommonBottomPopupVC.instantiate(appStoryboard: .Profile)
        popupVC.height = 260
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.leftStr = "Cancel"
        popupVC.rightStr = "Unlink"
        popupVC.titleStr = "Are you sure you want to unlink \(type) account? Next, we’ll create a password for your account."
        popupVC.noTapped = {
//            self.goBack(isGoingTab: true)
        }
        popupVC.yesTapped = {
            
            self.socialParams = [String:Any]()
            if sender.tag == 1{
                self.socialParams["type"] = "google"

            }
            else if sender.tag == 2{
                self.socialParams["type"] = "apple"

            }
            else if sender.tag == 3{
                self.socialParams["type"] = "facebook"

            }
            
            self.unlinkSocialAccount(success: { response in
                print("done")
                self.getLinkDate()

            }, failure: { errorResponse in
                print(errorResponse)
                if errorResponse["status"].intValue == 400 {
                    let popupVC: NewPasswordVC = NewPasswordVC.instantiate(appStoryboard: .Profile)
                    popupVC.height = 430
                    popupVC.presentDuration = 0.5
                    popupVC.dismissDuration = 0.5
                    popupVC.leftStr = "Cancel"
                    popupVC.rightStr = "Submit"
                    popupVC.titleStr = "Create a Password"
                    popupVC.noTapped = {
                    }
                    popupVC.yesTapped = {
                        
                        self.socialParams["password"] = UserDefaults.standard.object(forKey: "newPassword")

                        self.unlinkSocialAccount { response in
                            GeneralUtility.sharedInstance.showErrorMessage(message: "\(response["message"])")

                            
                            self.getLinkDate()
                        } failure: { errorResponse in
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.present(popupVC, animated: true, completion: nil)
                    }
                }
            })

        }
        DispatchQueue.main.async {
            self.present(popupVC, animated: true, completion: nil)
        }
        
    }
}

// MARK: - Tableview Methods

// MARK: - CollectionView Methods




// MARK: Social Login SDK

extension LinkUnlinkVC {
    
    func googleSignIn(isFirstTime: Bool = false) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
            DispatchQueue.main.async {
                self.HIDE_CUSTOM_LOADER()
            }
            guard error == nil else { return }

            self.socialParams = [String:Any]()
            self.socialParams["type"] = "google"
            self.socialParams["social_id"] = user?.user.userID ?? ""
            self.socialParams[kemail] = user?.user.profile?.email ?? ""

            DispatchQueue.main.async {
                self.checkSocial()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                GIDSignIn.sharedInstance.signOut()
            }
        }
    }
    
    func faceBookLogin(isFirstTime: Bool = false) {
//        let fbLoginManager : LoginManager = LoginManager()
//        fbLoginManager.logIn(permissions:   ["public_profile", "email"], from: self) { (fbloginresult, error) -> Void in
//            
//            if (error == nil) {
//                guard fbloginresult != nil else {
//                    return
//                }
//                
//                let permissionDictionary = [
//                    "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
//                let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
//                
//                pictureRequest.start { connection, result, error in
//                    
//                    if error == nil {
//                        guard let result = result else { return }
//                        
//                        let results = JSON(result)
//                        print("Logged in : \(String(describing: results))")
//                        
//                        self.socialParams = [String:Any]()
//                        self.socialParams["social_id"] = results["id"].stringValue
//                        self.socialParams["type"] = "facebook"
//                        self.socialParams[kemail] = results["email"].stringValue
//
//                        DispatchQueue.main.async {
//                            self.checkSocial()
//                        }
//                        
//                    } else {
//                        print("error \(String(describing: error.debugDescription))")
//                    }
//                }
//                let manager = LoginManager()
//                manager.logOut()
//            }
//        }
    }
    
    func appleSignIN(isFirstTime: Bool = false) {
        
        appleSignIn.didTapLoginWithApple()
        appleSignIn.appleSignInBlock = { (userInfo, message) in
            if let userInfo = userInfo{
                print(userInfo.email)
                print(userInfo.userid)
                
                self.socialParams = [String:Any]()
                self.socialParams["social_id"] = userInfo.userid
                self.socialParams["type"] = "apple"
                self.socialParams[kemail] = UserDefaults.standard.object(forKey: "AppleEmail") as? String ?? ""

                DispatchQueue.main.async {
                    self.checkSocial()
                }
                
            } else if let message = message {
                print("Error Message: \(message)")
                showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME , andMessage: "\(message)", buttons: ["Dismiss"]) { (i) in
                }
                return
            }else{
                print("Unexpected error!")
            }
        }
    }
    
    func checkSocial() {
        
        self.linkSocialAccount { response in
            print("done")
            self.getLinkDate()
        } failure: { errorResponse in
            print("error")
            GeneralUtility.sharedInstance.showErrorMessage(message: "\(errorResponse["message"])")

        }
    }
    
    
    func linkSocialAccount(isShowLoader : Bool = true, isShowErrorAlerts : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                
        ServiceManager.shared.postRequest(ApiURL: .linksocial, parameters: self.socialParams, isShowErrorAlerts: isShowErrorAlerts) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    
    func unlinkSocialAccount(isShowLoader : Bool = true, isShowErrorAlerts : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                
        ServiceManager.shared.postRequest(ApiURL: .unlinksocial, parameters: self.socialParams, isShowErrorAlerts: isShowErrorAlerts) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    
    func getSocialList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .socialLinks, parameters: [:]) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                if let dic = response["data"].dictionaryObject{
                    
                    self.lblGamilLink.text = "Link"
                    self.lblAppleLink.text = "Link"
                    self.lblFBLink.text = "Link"
                    self.isGoogle = false
                    self.isApple = false
                    self.isFB = false

                    self.viewGmail.isHidden = false
                    self.viewApple.isHidden = false
                    self.viewFacebook.isHidden = true

                    if dic["google"] as? Bool == true{
                        self.isGoogle = true
                        self.lblGamilLink.text = "Unlink"
                        self.viewGmail.isHidden = false
                        self.viewApple.isHidden = true


                    }
                    
                    else if dic["apple"] as? Bool == true{
                        self.isApple = true
                        self.lblAppleLink.text = "Unlink"
                        self.viewApple.isHidden = false
                        self.viewGmail.isHidden = true
                    }
                    
//                    if dic["facebook"] as? Bool == true{
//                        self.isFB = true
//                        self.lblFBLink.text = "Unlink"
//                    }
                }
            }
            else {
                failure(response)
            }
        } Failure: { response, isSuccess, error, statusCode in
            failure(response)
        }

      
    }
}




