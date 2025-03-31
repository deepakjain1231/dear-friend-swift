//
//  AudioViewModel.swift
//  DearFriends
//
//  Created by Harsh Doshi on 05/06/23.
//

import Foundation
import UIKit
import SwiftyJSON

class AudioViewModel {
    
    var limit = 10
    var offset = 0
    var haseMoreData = false
    var isAPICalling = false
    
    var arrOfAudioList = [CommonAudioList]()
    
    var currentFilterType: FilterTypes = .none
    var currentFilterIndex: Int?
    var currentAudioType: AudioTypeList = .normal
    
    var currentCategory: Category?
    var currentThemeCategory: ThemeCategory?
    var currentSubCategory: SubCategory?

    var arrOfBGAudios = [BGAudioListModel]()
}

extension AudioViewModel {
    
    func getAudioParams() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["limit"] = self.limit
        dict["offset"] = self.offset
        dict["type"] = self.currentAudioType.rawValue
                
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
    
    func getPlayedAudioList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var dict = [String: Any]()
        
        dict["limit"] = self.limit
        dict["offset"] = self.offset
        
        ServiceManager.shared.postRequest(ApiURL: .useraudiohistory, parameters: dict, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func getBackAudioList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .getBGAudio, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfBGAudios.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfBGAudios.append(BGAudioListModel(json: model))
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
    
    func playMusic(audio_id: String, audioProgress: String, isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.postRequest(ApiURL: .playMusic, parameters: ["audio_id": audio_id, "audio_progress": audioProgress], isShowLoader: isShowLoader, isShowErrorAlerts: false) { response, isSuccess, error, statusCode in
            
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
    
    func addOrRemoveLike(id: String, isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(newAPIURL: "\(ApiURL.addOrRemoveLike.strURL())/\((id))", ApiURL: .addOrRemoveLike, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func shareFeedback(id: Int?, categoryId: Int?, subCateId: Int?, rate: Double, description: String, isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        var param = [String: Any]()
        
        param["id"] = id
        param["category_id"] = categoryId
        param["sub_category_id"] = subCateId
        param["rate"] = rate
        param["description"] = description
        
        ServiceManager.shared.postRequest(ApiURL: .feedback, parameters: param, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
