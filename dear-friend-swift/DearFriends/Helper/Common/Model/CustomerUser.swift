//
//  CurrentUser.swift
//
//  Created by Himanshu Visroliya on 23/05/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate
import UIKit

class CurrentUser {
    
    static let shared = CurrentUser()
    
    var arrOfBGAudios = [BGAudioListModel]()
    var arrOfDownloadedBGAudios = [BGAudioListModel]()
    var authContent = [AuthContentModel]()
    
    var user: CurrentUserModel? {
        didSet {
            if let json = getJSON("CurrentUser") {
                self.user = CurrentUserModel(json: json)
            }
        }
    }
    
    init(user: CurrentUserModel? = nil) {
        if let json = getJSON("CurrentUser") {
            self.user = CurrentUserModel(json: json)
        } else {
            self.user = user
        }
    }
   
    func clear() {
        appDelegate.isPlanPurchased = false
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.removeObject(forKey: "screenOpenCount")
        UserDefaults.standard.synchronize()
    }
    
    func logoutUser() {
        self.LogoutAPI { _ in
            appDelegate.isPlanPurchased = false
            CurrentUser.shared.clear()
            appDelegate.setLoginRoot()
            CurrentUser.shared.user = nil
        } failure: { errorResponse in
            
        }
    }
   
    func LogoutAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .logout, parameters: [:]) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                }
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func getUserProfile(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        self.GetUserProfile(isShowLoader: isShowLoader) { response in
            appDelegate.finalAmountMain = response["custom_audio_request_price"].stringValue
            success(response)
        } failure: { errorResponse in
            
            failure(errorResponse)
        }
    }
    
    func GetUserProfile(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .getProfile, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func manageUserSubs(response: JSON) {
        appDelegate.isPlanPurchased = response["premium"].boolValue
    }
    
    func deleteAccount(reason: String, explantion: String, completion: @escaping (Bool)->Void) {
        SHOW_CUSTOM_LOADER()
        self.deleteReason(reason: reason, explantion: explantion) { response in
            HIDE_CUSTOM_LOADER()
            self.DeleteAccountAPI { _ in
                CurrentUser.shared.clear()
                appDelegate.setLoginRoot()
                completion(true)
            } failure: { errorResponse in
                completion(false)
            }
        } failure: { errorResponse in
            HIDE_CUSTOM_LOADER()
            completion(false)
        }
    }
   
    func DeleteAccountAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .deleteAccount, parameters: [:]) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    GeneralUtility().showSuccessMessage(message: response["message"].stringValue)
                }
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func deleteReason(reason: String, explantion: String, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        var params: [String: Any] = [:]
        params["reason"] = reason
        params["explantion"] = explantion
//        params["email"] = CurrentUser.shared.user?.email
        ServiceManager.shared.postRequest(ApiURL: .deleteReason, parameters: params, isShowLoader: false) { response, isSuccess, error, statusCode in
            
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
    
    
    func checkAnotherDeviceLoginService(success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        let params: [String: Any] = [:]

        ServiceManager.shared.postRequest(ApiURL: .anotherDeviceLogin, parameters: params, isShowLoader: false) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
            if (response["status"].int ?? 0) == 401 {
                NotificationCenter.default.post(name: Notification.Name("STOPMUSICPLAYER"), object: nil)
                CurrentUser.shared.clear()
                appDelegate.setLoginRoot()
            }
        }
    }
    
}

public class CurrentUserModel {
        
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCurrentUserNameKey: String = "name"
    private let kCurrentUserEmailKey: String = "email"
    private let kCurrentUserMobileKey: String = "mobile"
    private let kCurrentUserTokenKey: String = "token"
    private let kCurrentUserProfileImageKey: String = "profile_image"
    private let kCurrentUserAutoRenewalKey: String = "auto_renewal"
    private let kCurrentUserLastNameKey: String = "last_name"
    private let kCurrentUserInternalIdentifierKey: String = "id"
    private let kCurrentUserCountryCodeKey: String = "country_code"
    private let kCurrentUserPreferencesKey: String = "preferences"
    private let kCurrentUserPremiumKey: String = "premium"
    private let kCurrentUserFirstNameKey: String = "first_name"
    private let kCurrentUserCountryIso2CodeKey: String = "country_iso2_code"
    private let kCurrentUserExpiryDateKey: String = "expiry_date"
    
    // MARK: Properties
    public var name: String?
    public var email: String?
    public var mobile: String?
    public var token: String?
    public var profileImage: String?
    public var autoRenewal: String?
    public var lastName: String?
    public var internalIdentifier: Int?
    public var countryCode: String?
    public var preferences: [String]?
    public var premium: Int?
    public var firstName: String?
    public var countryIso2Code: String?
    public var expiryDate: String?
    var planType: String?
    var is_social: String = "0"
    var is_free_custom_audios: String = ""
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        name = json[kCurrentUserNameKey].string
        email = json[kCurrentUserEmailKey].string
        mobile = json[kCurrentUserMobileKey].string
        token = json[kCurrentUserTokenKey].string
        profileImage = json[kCurrentUserProfileImageKey].string
        autoRenewal = json[kCurrentUserAutoRenewalKey].string
        lastName = json[kCurrentUserLastNameKey].string
        is_social = json["is_social"].stringValue
        internalIdentifier = json[kCurrentUserInternalIdentifierKey].int
        countryCode = json[kCurrentUserCountryCodeKey].string
        if let items = json[kCurrentUserPreferencesKey].array { preferences = items.map { $0.stringValue } }
        premium = json[kCurrentUserPremiumKey].int
        firstName = json[kCurrentUserFirstNameKey].string
        countryIso2Code = json[kCurrentUserCountryIso2CodeKey].string
        expiryDate = json[kCurrentUserExpiryDateKey].string
        planType = json["plan_name"].stringValue
        is_free_custom_audios = json["is_free_custom_audios"].stringValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[kCurrentUserNameKey] = value }
        if let value = email { dictionary[kCurrentUserEmailKey] = value }
        if let value = mobile { dictionary[kCurrentUserMobileKey] = value }
        if let value = token { dictionary[kCurrentUserTokenKey] = value }
        if let value = profileImage { dictionary[kCurrentUserProfileImageKey] = value }
        if let value = autoRenewal { dictionary[kCurrentUserAutoRenewalKey] = value }
        if let value = lastName { dictionary[kCurrentUserLastNameKey] = value }
        if let value = internalIdentifier { dictionary[kCurrentUserInternalIdentifierKey] = value }
        if let value = countryCode { dictionary[kCurrentUserCountryCodeKey] = value }
        if let value = preferences { dictionary[kCurrentUserPreferencesKey] = value }
        if let value = premium { dictionary[kCurrentUserPremiumKey] = value }
        if let value = firstName { dictionary[kCurrentUserFirstNameKey] = value }
        if let value = countryIso2Code { dictionary[kCurrentUserCountryIso2CodeKey] = value }
        if let value = expiryDate { dictionary[kCurrentUserExpiryDateKey] = value }
        return dictionary
    }
    
}

func getJSON(_ key: String) -> JSON? {
    var p = ""
    if let result = UserDefaults.standard.string(forKey: key) {
        p = result
    }
    if p != "" {
        if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                return try JSON(data: json)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    } else {
        return nil
    }
}

func saveJSON(json: JSON, key:String) {
    if let jsonString = json.rawString() {
        UserDefaults.standard.setValue(jsonString, forKey: key)
    }
}

// MARK: Version Checker

extension CurrentUser {
    
    func versionCheckAPI() {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        ServiceManager.shared.postRequest(ApiURL: .versionChecker, parameters: [kType: "ios", kVersion: version], isShowLoader: false, isShowErrorAlerts: false) { (response, Success, message, statusCode) in
            
            print("Success Response:",response)
            
            let is_force_update = response["data"]["is_force_update"].stringValue
            
            appDelegate.contact_us_email = response["contact_us"]["email"].stringValue

            if Success == true {
                
                
            } else {
               
            }
            
        } Failure: { (response, Success, message, statusCode) in
            print("Failure Response:",response)
            
            let is_force_update = response["data"]["is_force_update"].stringValue

            if (statusCode == 200) {
                
            } else if statusCode == 412 {
                DispatchQueue.main.async {
                    if let topvc = UIApplication.topViewController2(), topvc is CommonBottomPopupVC {
                        
                        let data: [String: Any] = ["Message": message, "isForceUpdate": (is_force_update == "1")]
                        NotificationCenter.default.post(name: Notification.Name("RelodPopup"), object: nil, userInfo: data)
                                                        
                    } else {
                        if (is_force_update == "1") {
                            showAppUpdatePopup(isForceUpdate: true, Message: message)
                        } else {
                            showAppUpdatePopup(isForceUpdate: false, Message: message)
                        }
                    }
                    print("This is run on the main queue, after the previous code in outer block")
                }
            }
        }
    }
    
    func getBackAudioList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .getBGAudio, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                CurrentUser.shared.arrOfBGAudios.removeAll()
                response["data"].arrayValue.forEach { model in
                    CurrentUser.shared.arrOfBGAudios.append(BGAudioListModel(json: model))
                }
                                
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
