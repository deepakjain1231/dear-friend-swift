//
//  AuthViewModel.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 23/05/23.
//

import Foundation
import UIKit
import SwiftyJSON
import GoogleSignIn
//import FacebookCore
//import FacebookLogin

class AuthViewModel {
    
    var vc: UIViewController?
    
    var firstName : String = ""
    var lastName : String = ""
    var name : String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword : String = ""
    var countryCode : String = ""
    var countryShortCode : String = ""
    var mobile : String = ""
    var isTermsAccepted : Bool = false
    var otp = ""
    
    ///Change Password
    var opassword = ""
    var cpassword = ""
    var npassword = ""
    
    var profileImgData : Data?
    
    /// Social
    var socialParams = [String: Any]()
    private let appleSignIn = HSAppleSignIn()
    var isForSocial = false
    var socialType = ""
    var socialID = ""
}

// MARK: - Register

extension AuthViewModel {
    
    func getAuthContent(isShowLoader: Bool = false) {
        
        ServiceManager.shared.getRequest(ApiURL: .authContent, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                let arr = response["data"].arrayValue
                arr.forEach { model in
                    CurrentUser.shared.authContent.append(AuthContentModel(json: model))
                }               
            }
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
           
        }
    }
    
    func registerParams(type: String = "signup") -> [String: Any] {
        var params: [String: Any] = [kDeviceType: "ios",
                                       kDeviceID: UIDevice.current.identifierForVendor?.uuidString ?? "",
                                       kPushToken: appDelegate.deviceToken]
        
        params["email"] = self.email
        params["first_name"] = self.firstName
        params["last_name"] = self.lastName
        params["password"] = self.password
        params["country_code"] = self.countryCode
        params["mobile"] = self.mobile
        params["country_iso2_code"] = self.countryShortCode
        
        if self.otp != "" {
            params["otp"] = self.otp
        } else {
            params["type"] = type
        }
        
        return params
    }
    
    func isValidateRegister(isForOtP: Bool = false) -> Bool {
        
        guard let vc = self.vc else {
            return false
        }
        
        if self.firstName == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.nameMissing)
            return false
        }
        
        if self.lastName == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.lastnameMissing)
            return false
        }
        
        if self.email == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.EmailNameMissing)
            return false
        }
        
        if !self.email.isValidEmail()  {
            GeneralUtility().showErrorMessage(message: AlertMessage.ValidEmail)
            return false
        }
        
        if !self.isForSocial {
            
            if self.password == "" {
                GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMissing)
                return false
            }
            
            if self.password.count < 6 {
                GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMinMissing)
                return false
            }
            
            if self.confirmPassword == "" {
                GeneralUtility().showErrorMessage(message: AlertMessage.ConfirmPasswordMissing)
                return false
            }
            
            if self.confirmPassword.count < 6 {
                GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMinMissing)
                return false
            }
            
            if self.password != self.confirmPassword {
                GeneralUtility().showErrorMessage(message: AlertMessage.PasswordNotMatch2)
                return false
            }
        }
      
        if !self.isTermsAccepted {
            GeneralUtility().showErrorMessage(message: AlertMessage.termsMissing)
            return false
        }
        
        if isForOtP {
            if self.otp == "" {
                GeneralUtility().showErrorMessage(message: "Please enter OTP")
                return false
            }
            
            if self.otp.count < 6 {
                GeneralUtility().showErrorMessage(message: "Please enter 6 digit valid OTP")
                return false
            }
        }
    
        return true
    }
    
    func sendOTP(type: String = "signup", isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
       
        var params = self.registerParams(type: type)
        if type == "signup" {
            if self.isValidateRegister() == false {
                return
            }
        } else {
            if self.isValidEditProfile() == false {
                return
            }
            params = registerParams(type: "update")
        }
       
        ServiceManager.shared.postRequest(ApiURL: .sendOTP, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func registerAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidateRegister(isForOtP: true) == false {
            return
        }
                
        let params = registerParams()
        ServiceManager.shared.postRequest(ApiURL: .signup, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                saveJSON(json: response["data"], key: "CurrentUser")
                CurrentUser.shared.user = CurrentUserModel(json: response["data"])
                CurrentUser.shared.manageUserSubs(response: response["data"])
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
}

// MARK: - Login

extension AuthViewModel {
    
    func isValidLogin() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }
        
        if self.email == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.EmailNameMissing)
            return false
        }
        
        if !self.email.isValidEmail()  {
            GeneralUtility().showErrorMessage(message: AlertMessage.ValidEmail)
            return false
        }
        
        if self.password == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMissing)
            return false
        }
        
        if self.password.count < 6 {
            GeneralUtility().showErrorMessage(message: AlertMessage.PasswordMinMissing)
            return false
        }
        return true
    }
    
    func loginParams() -> [String: Any] {
        var params: [String: Any] = [kDeviceType: "ios",
                                       kDeviceID: UIDevice.current.identifierForVendor?.uuidString ?? "",
                                       kPushToken: appDelegate.deviceToken]
        
        params["email"] = self.email
        params["password"] = self.password
        
        return params
    }
    
    func loginAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidLogin() == false {
            return
        }
                
        let params = loginParams()
        ServiceManager.shared.postRequest(ApiURL: .login, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                saveJSON(json: response["data"], key: "CurrentUser")
                CurrentUser.shared.user = CurrentUserModel(json: response["data"])
                CurrentUser.shared.manageUserSubs(response: response["data"])
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
}

// MARK: - Forgot Password

extension AuthViewModel {
    
    func isValidForgot() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }
        
        if self.email == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.EmailNameMissing)
            return false
        }
        
        if !self.email.isValidEmail()  {
            GeneralUtility().showErrorMessage(message: AlertMessage.ValidEmail)
            return false
        }
      
        return true
    }
    
    func forgotPassParams() -> [String: Any] {
        var params: [String: Any] = [:]
        params["email"] = self.email
        
        return params
    }
    
    func forgotPassAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidForgot() == false {
            return
        }
                
        let params = forgotPassParams()
        ServiceManager.shared.postRequest(ApiURL: .forgotPassword, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
}

// MARK: - Edit Profile

extension AuthViewModel {
    
    func isValidEditProfile() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }
        
        if self.firstName == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.nameMissing)
            return false
        }
        
        if self.lastName == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.lastnameMissing)
            return false
        }
        
//        if self.mobile == "" {
//            GeneralUtility().showErrorMessage(message: AlertMessage.MobileMissing)
//            return false
//        }
        
        if self.email == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.EmailNameMissing)
            return false
        }
        
        if !self.email.isValidEmail()  {
            GeneralUtility().showErrorMessage(message: AlertMessage.ValidEmail)
            return false
        }
      
        return true
    }
    
    func editProfilePass() -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["email"] = self.email
        params["first_name"] = self.firstName
        params["last_name"] = self.lastName
        params["country_code"] = self.countryCode
        params["mobile"] = self.mobile
        params["country_iso2_code"] = self.countryShortCode
        
        if self.otp != "" {
            params["otp"] = self.otp
        }
        
        return params
    }
    
    func editProfileAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidEditProfile() == false {
            return
        }
                
        let params = self.editProfilePass()
        let imgVideoParam: [ServiceManager.MultiPartDataType] = [ServiceManager.MultiPartDataType.init(fileData: self.profileImgData!, keyName: "profile_image")]
        ServiceManager.shared.postMultipartRequest(ApiURL: .updateProfile, imageVideoParameters: imgVideoParam, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                saveJSON(json: response["data"], key: "CurrentUser")
                CurrentUser.shared.user = CurrentUserModel(json: response["data"])
                GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
}

// MARK: Change Password API

extension AuthViewModel {
    
    private func getChangePassword() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["old_password"] = self.opassword
        dict["new_password"] = self.npassword
        
        return dict
    }
    
    private func changePassValidation() -> Bool {
        
        if self.opassword == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.oldPasswordMissing)
            return false
        }
        
        if self.opassword.count < 6 {
            GeneralUtility().showErrorMessage(message: "Please enter old Password atleast 6 characters")
            return false
        }
        
        if self.npassword == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.NewpasswordMissing)
            return false
        }
        
        if self.npassword.count < 6 {
            GeneralUtility().showErrorMessage(message: "Please enter new Password atleast 6 characters")
            return false
        }
        
        if self.cpassword == "" {
            GeneralUtility().showErrorMessage(message: AlertMessage.ConfirmPasswordMissing)
            return false
        }
        
        if self.cpassword.count < 6 {
            GeneralUtility().showErrorMessage(message: "Please enter confirm Password atleast 6 characters")
            return false
        }
        
        if self.cpassword != self.npassword {
            GeneralUtility().showErrorMessage(message: "New password and confirm password doesn't match.")
            return false
        }
        
        return true
    }
    
    func ChangePassword(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.changePassValidation() == false {
            return
        }
        
        ServiceManager.shared.postRequest(ApiURL: .changePassword, parameters: self.getChangePassword()) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
}

// MARK: Social Login SDK

extension AuthViewModel {
    
    func googleSignIn(isFirstTime: Bool = false) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self.vc!) { user, error in
            DispatchQueue.main.async {
                self.vc?.HIDE_CUSTOM_LOADER()
            }
            guard error == nil else { return }
            
            self.socialParams[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
            self.socialParams[kDeviceType] = kiOS
            self.socialParams[kPushToken] = appDelegate.deviceToken
            self.socialParams["type"] = "google"
            self.socialParams["social_id"] = user?.user.userID ?? ""
            self.socialParams[kemail] = user?.user.profile?.email ?? ""
            
            let nameArray = (user?.user.profile?.name ?? "").components(separatedBy: " ")
            self.socialParams["first_name"] = nameArray.first ?? ""
            self.socialParams["last_name"] = nameArray.last ?? ""
            
            self.firstName = nameArray.first ?? ""
            self.lastName = nameArray.last ?? ""
            self.email = user?.user.profile?.email ?? ""
            
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
//        fbLoginManager.logIn(permissions:   ["public_profile", "email"], from: self.vc!) { (fbloginresult, error) -> Void in
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
//                        var parameters = [String:Any]()
//                        parameters["social_id"] = results["id"].stringValue
//                        let nameArray = results["name"].stringValue.components(separatedBy: " ")
//                        parameters["first_name"] = nameArray.first ?? ""
//                        parameters["last_name"] = nameArray.last ?? ""
//                        parameters[kemail] = results["email"].stringValue
//                        parameters["type"] = "facebook"
//                        parameters[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//                        parameters[kDeviceType] = kiOS
//                        parameters[kPushToken] = appDelegate.deviceToken
//                        
//                        self.firstName = nameArray.first ?? ""
//                        self.lastName = nameArray.last ?? ""
//                        self.email = results["email"].stringValue
//                        self.socialParams = parameters
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
                
                var parameter = [String:Any]()
                parameter[kType] = kApple
                parameter["social_id"] = userInfo.userid
                parameter[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
                parameter[kDeviceType] = kiOS
                parameter["type"] = "apple"
                parameter[kPushToken] = appDelegate.deviceToken
                parameter[kemail] = UserDefaults.standard.object(forKey: "AppleEmail") as? String ?? ""
                self.email = UserDefaults.standard.object(forKey: "AppleEmail") as? String ?? ""
                parameter["first_name"] = userInfo.firstName
                parameter["last_name"] = userInfo.lastName
                 
                self.firstName = userInfo.firstName
                self.lastName = userInfo.lastName
                self.email = userInfo.email
                
                self.socialParams = parameter
                self.socialType = "apple"
                
                DispatchQueue.main.async {
                    self.checkSocial()
                }
                
            } else if let message = message {
                print("Error Message: \(message)")
                showAlertWithTitleFromVC(vc: self.vc!, title: Constant.APP_NAME , andMessage: "\(message)", buttons: ["Dismiss"]) { (i) in
                }
                return
            }else{
                print("Unexpected error!")
            }
        }
    }
    
    func checkSocial() {
        self.CheckSocialAvbl { response in
            appDelegate.setTabbarRoot()
        } failure: { errorResponse in
            GeneralUtility.sharedInstance.showErrorMessage(message: "\(errorResponse["message"])")

            if errorResponse["status"].intValue == 412 {
//                if let vc2 = self.vc as? RegisterVC {
//                    vc2.authVM.socialParams = self.socialParams
//                    vc2.authVM.firstName = self.firstName
//                    vc2.authVM.lastName = self.lastName
//                    vc2.authVM.email = self.email
//                    vc2.isForSocial = true
//                    vc2.setupUI()
//                } else {
//                    let vc: RegisterVC = RegisterVC.instantiate(appStoryboard: .main)
//                    vc.authVM.socialParams = self.socialParams
//                    vc.authVM.firstName = self.firstName
//                    vc.authVM.lastName = self.lastName
//                    vc.authVM.email = self.email
//                    vc.isForSocial = true
//                    self.vc?.navigationController?.pushViewController(vc, animated: true)
//                }
            }
        }
    }
    
    func CheckSocialAvbl(isShowLoader : Bool = true, isShowErrorAlerts : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        self.socialParams["device_type"] = "ios"
        self.socialParams["push_token"] = appDelegate.deviceToken
        self.socialParams["device_id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        ServiceManager.shared.postRequest(ApiURL: .socialCheck, parameters: self.socialParams, isShowErrorAlerts: isShowErrorAlerts) { response, isSuccess, error, statusCode in
            print("Success Response:", response)
            if isSuccess == true {
                saveJSON(json: response["data"], key: "CurrentUser")
                CurrentUser.shared.user = CurrentUserModel(json: response["data"])
                CurrentUser.shared.manageUserSubs(response: response["data"])
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    

}
