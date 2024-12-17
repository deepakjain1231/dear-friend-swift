//
//  ProfileViewModel.swift
//  DearFriends
//
//  Created by Harsh Doshi on 05/06/23.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewModel {
    
    var timeMode = "AM"
    var arrOfDays = [DaysList]()
    var titleStr = ""
    var isAnySelected = false
    var time = ""
    
    var arrOfReminderList = [ReminderListingModel]()
    var limit = 10
    var offset = 0
    var haseMoreData = false
    var isAPICalling = false
    
    var current: ReminderListingModel?
    
    var arrOfCategory = [Category]()
    
    var reminderTitle = ""
    var reminderDate = ""
    var reminderTime = ""
    
    func resetPagination() {
        self.arrOfReminderList.removeAll()
        self.limit = 10
        self.offset = 0
        self.haseMoreData = false
        self.isAPICalling = false
    }
}

// MARK: - Reminder

extension ProfileViewModel {
    
    func isValidate() -> Bool {
        if self.titleStr == "" {
            GeneralUtility().showErrorMessage(message: "Please enter title")
            return false
        }
        
        if self.isAnySelected == false {
            GeneralUtility().showErrorMessage(message: "Please select at least one day")
            return false
        }
        
        if self.time == "" {
            GeneralUtility().showErrorMessage(message: "Please enter time")
            return false
        }
        
        return true
    }
    
    func getReminderParams(id: String = "") -> [String: Any] {
        var dict = [String: Any]()
        
        if id != "" {
            dict["id"] = id
        }
        
        dict["time"] = self.reminderTime
        dict["title"] = self.reminderTitle
        dict["date"] = self.reminderDate
        
        return dict
    }
    
    func addReminder(id: String = "", isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
              
        let params = self.getReminderParams(id: id)
        ServiceManager.shared.postRequest(ApiURL: .addReminder, parameters: params) { response, isSuccess, error, statusCode in
            
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
    
    func updateReminder(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
             
        let params = getReminderParams(id: "\(self.current?.internalIdentifier ?? 0)")
        ServiceManager.shared.postRequest(ApiURL: .updateReminder, parameters: params) { response, isSuccess, error, statusCode in
            
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
    
    func getReminderList(date: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var param = ["limit": self.limit,
                     "offset": self.offset] as [String : Any]
        
        if date != "" {
            param["date"] = date
        }
        
        ServiceManager.shared.postRequest(ApiURL: .getReminder, parameters: param, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                let arr = response["data"].arrayValue
                if self.offset == 0 {
                    self.arrOfReminderList.removeAll()
                }
                arr.forEach { modeel in
                    self.arrOfReminderList.append(ReminderListingModel(json: modeel))
                }
                self.haseMoreData = arr.count >= 10
                self.isAPICalling = false
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func deleteReminder(id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(newAPIURL: "\(ApiURL.deleteReminder.strURL())/\(id)", ApiURL: .deleteReminder, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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

// MARK: - Preferences

extension ProfileViewModel {
 
    func isValidateForPref() -> Bool {
        let finalArray = self.arrOfCategory.flatMap({$0.subCategory ?? []}).filter({$0.isSelect})
        if finalArray.count == 0 {
            GeneralUtility().showErrorMessage(message: "Please select at least one category")
            return false
        }
        
        return true
    }
    
    func getPrefParams() -> [String: Any] {
        var dict = [String: Any]()
        
        let finalArray = self.arrOfCategory.flatMap({$0.subCategory ?? []}).filter({$0.isSelect})
        
        var index = 0
        for it in finalArray {
            dict["preferences[\(index)]"] = "\(it.internalIdentifier ?? 0)"
            index += 1
        }
        
        return dict
    }
    
    func updatePreferences(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidateForPref() == false {
            return
        }
                
        let params = getPrefParams()
        ServiceManager.shared.postRequest(ApiURL: .updatePref, parameters: params) { response, isSuccess, error, statusCode in
            
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


//MARK: - Contact support

extension ProfileViewModel {
    
    func contactSupport(type: String, title: String, photos: [UIImage?]? ,video: URL?, message: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params : [String:Any] = [:]
        params["type"] = type
        params["title"] = title
        params["message"] = message
        
        var imgVideoParam: [ServiceManager.MultiPartDataType] = []
        // Handle photos
        if let photos = photos {
            for photo in photos {
                if let profileImgData = photo?.jpegData(compressionQuality: 0.8) {
                    // Use the same key "photo[]" for each image
                    imgVideoParam.append(ServiceManager.MultiPartDataType(fileData: profileImgData, keyName: "photo[]"))
                }
            }
        }
        
        // Handle video
        if let videourl = video, let videoData = NSData(contentsOf: videourl) {
            imgVideoParam.append(ServiceManager.MultiPartDataType(fileData: videoData as Data, keyName: "video"))
        }

        ServiceManager.shared.postMultipartRequest(ApiURL: .contact, imageVideoParameters: imgVideoParam, parameters: params) { response, isSuccess, error, statusCode in
            
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
