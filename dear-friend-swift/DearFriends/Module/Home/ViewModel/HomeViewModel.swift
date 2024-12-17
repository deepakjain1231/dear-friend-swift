//
//  HomeViewModel.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 30/05/23.
//

import Foundation
import UIKit
import SwiftyJSON

enum FilterTypes: String, CaseIterable {
    case none = ""
    case newest = "newest"
    case oldest = "oldest"
    case duration_high = "duration_high"
    case duration_low = "duration_low"
}

enum AudioTypeList: String, CaseIterable {
    case beginner = "beginner"
    case top_picks = "top_picks"
    case recommended = "recommended"
    case normal = "normal"
    case liked = "liked"
}

class HomeViewModel {
    
    var homedataModel: HomeDataModel?
    var currentCategory: Category?
    var currentThemeCategory: ThemeCategory?
    var currentSubCategory: SubCategory?
    var currentContentId = 0
    static let shared = HomeViewModel()
    
    var limit = 10
    var offset = 0
    var haseMoreData = false
    var isAPICalling = false
    
    var arrOfAudioList = [CommonAudioList]()
    
    var currentFilterType: FilterTypes = .none
    var currentAudioType: AudioTypeList = .normal
    
    var arrOfNotifications = [NotificationListModel]()
    
    var arrOfHomeContentData = [HomeContentList]()
    var arrOfHomeDynamic = [HomeDynamicModel]()
    var homeDynamic : HomeDynamicModel?
}

// MARK: - Get Home Screen Data

extension HomeViewModel {
    
    func getHomeData(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .homeData, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.homedataModel = HomeDataModel(json: response["data"])
                
                appDelegate.unread_count = response["data"]["unread_count"].intValue
                UIApplication.shared.applicationIconBadgeNumber = appDelegate.unread_count
                
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func getHomeDynamicList(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .dynamicList, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfHomeDynamic.removeAll()
                response["data"].arrayValue.forEach { model in
                    if model["name"] != "category" && model["name"] != "unread_count"{
                        self.arrOfHomeDynamic.append(HomeDynamicModel(json: model))
                    } else if  model["name"] == "unread_count"{
                        appDelegate.unread_count = model["count"].intValue
                    }
                    
                    
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
    
    func getHomeContentData(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .home_content, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfHomeContentData.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfHomeContentData.append(HomeContentList(json: model))
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

// MARK: - Get Audio List

extension HomeViewModel {
    
    func getAudioParams() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["limit"] = self.limit
        dict["offset"] = self.offset
        dict["type"] = self.currentAudioType.rawValue
        
        if self.currentContentId != 0 {
            dict["home_id"] = currentContentId
        }
                
        if let category_id = self.currentCategory?.internalIdentifier {
            dict["category_id"] = category_id
        }
        
        if let theme_category_id = self.currentThemeCategory?.internalIdentifier {
            dict["theme_category_id"] = theme_category_id
        }
        
        
        if let sub_category_id = self.currentSubCategory?.internalIdentifier {
            dict["sub_category_id"] = sub_category_id
        }
        
        if self.currentFilterType != .none {
            dict["filter"] = self.currentFilterType.rawValue
        }
        
        return dict
    }
    
    func getAudioList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.postRequest(ApiURL: .getAudioList, parameters: self.getAudioParams(), isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfAudioList.removeAll()
                let arr = response["data"].arrayValue
                if self.offset == 0 {
                    self.arrOfAudioList.removeAll()
                }
                arr.forEach { modeel in
                    self.arrOfAudioList.append(CommonAudioList(json: modeel))
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
    
    func getNotifications(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var dict = [String: Any]()
        
        dict["limit"] = self.limit
        dict["offset"] = self.offset
        
        ServiceManager.shared.postRequest(ApiURL: .getNotifications, parameters: dict, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                let arr = response["data"].arrayValue
                if self.offset == 0 {
                    self.arrOfNotifications.removeAll()
                }
                arr.forEach { modeel in
                    self.arrOfNotifications.append(NotificationListModel(json: modeel))
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
    
    func deleteOneNotifcation(id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var dict = [String: Any]()
        
        dict["id"] = id
        
        ServiceManager.shared.postRequest(ApiURL: .deletenotification, parameters: dict, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func readNotifcation(id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var dict = [String: Any]()
        
        dict["id"] = id
        
        ServiceManager.shared.postRequest(ApiURL: .readnotification, parameters: dict, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func deleteAllNotifcation(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var dict = [String: Any]()
        
        dict["is_clear_all"] = "1"
        
        ServiceManager.shared.postRequest(ApiURL: .deletenotification, parameters: dict, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
}

// MARK: - Pin Audio

extension HomeViewModel {
    
    func pinAudio(audio_id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.postRequest(ApiURL: .pinAudio, parameters: ["audio_id": audio_id], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
}

// MARK: - Favourite Audio

extension HomeViewModel {
    
    func addOrRemoveLike(audio_id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(newAPIURL: "\(ApiURL.addOrRemoveLike.strURL())/\((audio_id))", ApiURL: .addOrRemoveLike, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
}
