//
//  CreateCustomAudioViewModel.swift
//  DearFriends
//
//  Created by Harsh Doshi on 09/11/23.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftDate

class CustomMessageListing {
    
    var currentDate = ""
    var arrOfMessages = [ChatMessageListingModel]()
    
    init(currentDate: String = "", arrOfMessages: [ChatMessageListingModel] = [ChatMessageListingModel]()) {
        self.currentDate = currentDate
        self.arrOfMessages = arrOfMessages
    }
}

class CreateCustomAudioViewModel {
    
    var format = ""
    var script_file = ""
    var goals_and_challenges = ""
    var pause_duration = ""
    var voice_id = ""
    var meditation_name = ""
    var voiceID = ""
    var selectedDoc: ServiceManager.MultiPartDataType?
    var arrOfSampleAudioList = [SampleAudioList]()
    
    var arrOfCustomRequests = [CustomAudioRequestListingModel]()
    var type = "open"
    
    var currentCustomID = ""
    var currenRequest: CustomAudioRequestListingModel?
    var arrOfMessages = [CustomMessageListing]()
    var currentMessage: ChatMessageListingModel?
    
    /// For My Own Script
    var total_amount = ""
    var sub_total = ""
    var transaction_id = ""
    var currency = ""
    
    func pinAudio(audio_id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.postRequest(ApiURL: .pinCustomAudio, parameters: ["custom_audio_id": audio_id], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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

// MARK: - Sample Audio List

extension CreateCustomAudioViewModel {
    
    func getSampleAudioList(isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.getRequest(ApiURL: .getSampleAudio, parameters: [:], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfSampleAudioList.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfSampleAudioList.append(SampleAudioList(json: model))
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

// MARK: - Custom Audio Requests

extension CreateCustomAudioViewModel {
    
    func getCustomAudioRequests(isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        ServiceManager.shared.postRequest(ApiURL: .customize_audio_request_list, parameters: ["type": self.type], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfCustomRequests.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfCustomRequests.append(CustomAudioRequestListingModel(json: model))
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

// MARK: - Create Custom Request

extension CreateCustomAudioViewModel {
    
    func createCustomRequest(isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        
        params["format"] = self.format
        params["script_file"] = self.script_file
        params["goals_and_challenges"] = self.goals_and_challenges
        params["pause_duration"] = self.pause_duration
        params["voice_id"] = self.voiceID
        params["meditation_name"] = self.meditation_name
        
        var imgVideoParam = [ServiceManager.MultiPartDataType]()
        if let current = self.selectedDoc {
            imgVideoParam = [current]
        }
        
        if self.script_file == "yes" {
            params["total_amount"] = self.total_amount
            params["sub_total"] = self.sub_total
            params["charge"] = "0"
            params["transaction_id"] = self.transaction_id
            params["payment_status"] = "succeed"
            params["currency"] = self.currency
        }
        
        ServiceManager.shared.postMultipartRequest(ApiURL: .customize_audio_request, imageVideoParameters: imgVideoParam, parameters: params) { response, isSuccess, error, statusCode in
            
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

// MARK: - Chat Message Listing

extension CreateCustomAudioViewModel {
    
    func getChatHistory(isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        params["custom_audio_request_id"] = self.currentCustomID
        
        ServiceManager.shared.postRequest(ApiURL: .getChatHistory, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfMessages.removeAll()
                
                self.currenRequest = CustomAudioRequestListingModel(json: response["custom_audio_request"])
                
                response["data"].arrayValue.forEach { model in
                    let current = ChatMessageListingModel(json: model)
                    let messageDate = current.createdAt?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", region: .UTC)?.convertTo(region: .local).toFormat("yyyy-MM-dd", locale: Locale(identifier: "en_US_POSIX")) ?? ""
                    
                    if let index = self.arrOfMessages.firstIndex(where: {$0.currentDate == messageDate}) {
                        self.arrOfMessages[index].arrOfMessages.append(current)
                    } else {
                        let temp = CustomMessageListing(currentDate: messageDate, arrOfMessages: [current])
                        self.arrOfMessages.append(temp)
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
}

// MARK: - Chat Message

extension CreateCustomAudioViewModel {
    
    func sendChat(value: String, isShowLoader: Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        params["custom_audio_request_id"] = self.currentCustomID
        params["to_user_id"] = "1"
        params["type"] = "message"
        params["message"] = value
        
        ServiceManager.shared.postRequest(ApiURL: .sendChat, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func sendAttachment(value: String, isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        params["custom_audio_request_id"] = self.currentCustomID
        params["to_user_id"] = "1"
        params["type"] = "file"
        params["message"] = value
        
        var imgVideoParam = [ServiceManager.MultiPartDataType]()
        if let current = self.selectedDoc {
            imgVideoParam = [current]
        }
        ServiceManager.shared.postMultipartRequest(ApiURL: .sendChat, imageVideoParameters: imgVideoParam, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.selectedDoc = nil
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    func editRequest(value: String, isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        params["custom_audio_request_id"] = self.currentCustomID
        params["message"] = value
        
        ServiceManager.shared.postRequest(ApiURL: .editRequest, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func deleteRequest(isShowLoader: Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params: [String: Any] = [:]
        params["id"] = self.currentCustomID
        
        ServiceManager.shared.postRequest(ApiURL: .deleteRequest, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
