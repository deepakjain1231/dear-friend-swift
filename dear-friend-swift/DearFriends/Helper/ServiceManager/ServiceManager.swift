//
//  ServiceManager.swift
//  DemoServiceManage
//
//  Created by Zestbrains on 11/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

typealias APIResponseBlock = ((_ response: JSON,_ isSuccess: Bool,_ error: String ,_ statusCode : Int?)->())
typealias APIResponseBlockWithStatusCode = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())
typealias APIFailureResponseBlock = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())

enum ApiURL {
    
    case none
    case baseURL
    case signup
    case terms
    case login
    case tokenUpdate
    case logout
    case updateProfile
    case getProfile
    case aboutUS
    case privacy
    case deleteAccount
    case changePassword
    case forgotPassword
    case sendOTP
    case versionChecker
    case homeData
    case getAudioList
    case addOrRemoveLike
    case addReminder
    case getReminder
    case deleteReminder
    case updateReminder
    case purchasePlan
    case updatePref
    case onboarding_content
    case onboarding_about_creator
    case getSampleAudio
    case customize_audio_request
    case customize_audio_request_list
    case videoList
    case getChatHistory
    case pinAudio
    case instructor_video_details
    case instructoravailabilitydates
    case instructoravailabilitytimeslot
    case getBGAudio
    case bookVideo
    case myBooking
    case getNotifications
    case sendChat
    case payForCustom
    case editRequest
    case pinCustomAudio
    case playMusic
    case useraudiohistory
    case socialCheck
    case linksocial
    case unlinksocial
    case socialLinks
    case user_agreement_create_section
    case user_agreement_booking
    case restoreplan
    case home_content
    case deleteRequest
    case deletenotification
    case readnotification
    case bookingdetail
    case deleteReason
    case contact
    case feedback
    case authContent
    case dynamicList
    case anotherDeviceLogin
    
    func strURL() -> String {
        var str: String  = ""
        
        switch self {
        case .none:
            return ""
        case .baseURL:
            return "https://api.mydearfriends.org/V1/"
        case .signup:
            str = "signup"
        case .terms:
            str = "content/term_condition"
        case .login:
            str = "login"
        case .tokenUpdate:
            str = "user/token-update"
        case .logout:
            str = "user/logout"
        case .updateProfile:
            str = "user/edit"
        case .getProfile:
            str = "user/profile"
        case .aboutUS:
            str = "content/about_us"
        case .privacy:
            str = "content/privacy_policy"
        case .deleteAccount:
            str = "user/delete"
        case .changePassword:
            str = "user/update_password"
        case .forgotPassword:
            str = "forgot_password"
        case .sendOTP:
            str = "send_otp"
        case .versionChecker:
            str = "version_checker"
        case .homeData:
            str = "home/list"
        case .getAudioList:
            str = "home/audios"
        case .addOrRemoveLike:
            str = "home/like_unlike"
        case .addReminder:
            str = "reminders/create"
        case .getReminder:
            str = "reminders/list"
        case .deleteReminder:
            str = "reminders/delete"
        case .updateReminder:
            str = "reminders/update"
        case .purchasePlan:
            str = "payment/subscribe"
        case .updatePref:
            str = "user/update_preference"
        case .onboarding_content:
            str = "onboarding_content"
        case .onboarding_about_creator:
            str = "about-the-creator"
        case .getSampleAudio:
            str = "get-sample-audio"
        case .customize_audio_request:
            str = "user/customize_audio_request"
        case .customize_audio_request_list:
            str = "user/customize_audio_request_list"
        case .videoList:
            str = "home/videos"
        case .getChatHistory:
            str = "user/chat-history"
        case .pinAudio:
            str = "user/pin-audio"
        case .instructor_video_details:
            str = "home/instructor-video-details"
        case .instructoravailabilitydates:
            str = "home/instructor-availability-dates"
        case .instructoravailabilitytimeslot:
            str = "home/instructor-availability-time-slot"
        case .getBGAudio:
            str = "home/background-audio"
        case .bookVideo:
            str = "user/book-video"
        case .myBooking:
            str = "user/my-bookings"
        case .getNotifications:
            str = "user/get-notifications"
        case .sendChat:
            str = "user/send-chat"
        case .payForCustom:
            str = "user/pay-now"
        case .editRequest:
            str = "user/edit_customize_audio_request_list"
        case .pinCustomAudio:
            str = "user/pin-custom-audio"
        case .playMusic:
            str = "user/play-audio"
        case .useraudiohistory:
            str = "home/user-audio-history"
        case .socialCheck:
            str = "social-login"
        case .user_agreement_create_section:
            str = "content/user_agreement_create_section"
        case .user_agreement_booking:
            str = "content/user_agreement_booking"
        case .restoreplan:
            str = "payment/restore-plan"
        case .home_content:
            str = "home_content"
        case .deleteRequest:
            str = "user/delete-custom-audio-request"
        case .deletenotification:
            str = "user/delete-notification"
        case .readnotification:
            str = "user/read-notification"
        case .bookingdetail:
            str = "user/booking-detail"
        case .deleteReason:
            str = "delete-reason"
        case .contact:
            str = "contact"
        case .feedback:
            str = "feedback"
        case .authContent:
            str = "auth_content"
        case .dynamicList:
            str = "home/dynamic-list"
        case .linksocial:
            str = "user/social/link"
        case .unlinksocial:
            str = "user/social/unlink"
        case .socialLinks:
            str = "user/social"
        case .anotherDeviceLogin:
            str = "token-check"

        }
            
        return ApiURL.baseURL.strURL() + str
    }
}

class ServiceManager: NSObject {
    
    static let shared: ServiceManager = ServiceManager()
    let manager: Session
    
    var isPrintResponse = true
//    
   
    var headers: HTTPHeaders {
        var header: HTTPHeaders = ["Accept-Language": "en"]
        if (CurrentUser.shared.user?.token ?? "") != "" {
            header["vAuthorization"] = "Bearer \(CurrentUser.shared.user?.token ?? "")"
        }
        return header
    }
    
    var pushHeaders: HTTPHeaders {
        let header: HTTPHeaders = ["Content-Type": "application/json", "Authorization": "key=\(GoogleFCMServerKey)"]
        return header
    }
    
    var paramEncode: ParameterEncoding = URLEncoding.default
    
    override init() {
        let memoryCapacity = 50 * 1024 * 1024  // 50 MB
        let diskCapacity = 100 * 1024 * 1024   // 100 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myCache")
        URLCache.shared = cache

        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60*2
        configuration.timeoutIntervalForResource = 60*2
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        
        manager = Session(configuration: configuration)
        
        
        super.init()
    }
    
    // MARK:- API CAlling methods
    
    //GET
    func getRequest(newAPIURL: String = "" ,ApiURL : ApiURL , strAddInURL : String = "",
                    parameters : [String: Any] ,
                    isShowLoader : Bool = true,
                    isPassHeader : Bool = true,
                    isPrintData : Bool = true,
                    isShowErrorAlerts : Bool = true,
                    Success successBlock:@escaping APIResponseBlock,
                    Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {
                
                let url = try getFullUrl(relPath: (newAPIURL == "" ? ApiURL.strURL() : newAPIURL))
                
                //CATCH DATA
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

                guard let finalURL = components.url else { return }
                
                print("API URL: \(url)")

                // ⚡️ Check for cached response
                if ApiURL == .dynamicList || ApiURL == .homeData || ApiURL == .onboarding_about_creator {
                    if let getData = SDKUserDefault.getJSONData(for: finalURL.absoluteString) {
                        self.handleSucess(json: getData, statusCode: 200, strUrl: "\(url)", isLoadData: true, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }
                    else {
                        if isShowLoader {
                            DispatchQueue.main.async {
                                SHOW_CUSTOM_LOADER()
                            }
                        }
                    }
                }

                
                
                let parameters = parameters

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)
                
                _ = manager.request(url, method: .get, parameters: parameters, encoding: paramEncode, headers: header).responseData(completionHandler: { (resObj) in
                    
                    if isShowLoader {
                        DispatchQueue.main.async {
                            HIDE_CUSTOM_LOADER()
                        }
                    }
                    
                    self.printSucess(strUrl: "\(url)", json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0
                    
                    switch resObj.result {
                    case .success(let json) :
                        
                        if isPrintData {
                            print("SuccessJSON \(json)")
                        }
                       
                        //SAVE CATCH DATA
                        if ApiURL == .dynamicList || ApiURL == .homeData || ApiURL == .onboarding_about_creator{
                            if let data = resObj.data {
                                SDKUserDefault.saveJSONData(data, for: finalURL.absoluteString)
                            }
                        }

                        self.handleSucess(json: json, statusCode: statusCode, strUrl: "\(url) | \(header) | \(parameters)", isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                        
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }
                        
                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, strUrl: "\(url)", Success: successBlock, Failure: failureBlock)
                    }
                    
                })
            }
            
        }catch let error {
            self.jprint(items: error)
            if isShowLoader {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                }
            }
        }
    }
    
    
    //POST
    func postRequest(ApiURL : ApiURL , strURLAdd : String = "",
                     parameters : [String: Any] ,
                     isShowLoader : Bool = true,
                     isPassHeader : Bool = true,
                     additionalHeader : HTTPHeaders = [:],
                     isShowErrorAlerts : Bool = true,
                     Success successBlock:@escaping APIResponseBlock,
                     Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = additionalHeader
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {

                let url = try getFullUrl(relPath: ApiURL.strURL() + strURLAdd)
                
                //CATCH DATA
                var cache_url = try getFullUrl(relPath: ApiURL.strURL() + strURLAdd)
                
                if let jsonString = jsonStringSorted(from: parameters) {
                    cache_url = try getFullUrl(relPath: ApiURL.strURL() + strURLAdd + "/\(jsonString)")
                }

                // ⚡️ Check for cached response
                if ApiURL == .getAudioList || ApiURL == .useraudiohistory {
                    if let getData = SDKUserDefault.getJSONData(for: cache_url.absoluteString) {
                        self.handleSucess(json: getData, statusCode: 200, strUrl: "\(url)", isLoadData: true, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }
                    else {
                        if isShowLoader {
                            DispatchQueue.main.async {
                                SHOW_CUSTOM_LOADER()
                            }
                        }
                    }
                }
                
                let parameters = parameters
                
                //printing headers and parametes
                printStart(header: header, Parameter: parameters, url: url)
                
                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseData(completionHandler: { (resObj) in
                    
                    if isShowLoader {
                        DispatchQueue.main.async {
                            HIDE_CUSTOM_LOADER()
                        }
                    }
                    
                    self.printSucess(strUrl: "\(url)", json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0
                    
                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                        
                        //SAVE CATCH DATA
                        if ApiURL == .getAudioList || ApiURL == .useraudiohistory{
                            if let data = resObj.data {
                                SDKUserDefault.saveJSONData(data, for: cache_url.absoluteString)
                            }
                        }
                        
                        self.handleSucess(json: json, statusCode: statusCode, strUrl: "\(url) | \(header) | \(parameters)", isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                        
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }
                        
                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, strUrl: "\(url)", Success: successBlock, Failure: failureBlock)
                    }
                    
                })
            }
            
        } catch let error {
            self.jprint(items: error)
            if isShowLoader {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                }
            }
        }
    }
    
    
    func postRequestForStipe(ApiURL : String, strURLAdd : String = "",
                               parameters : [String: Any] ,
                               isShowLoader : Bool = true,
                               isPassHeader : Bool = true,
                               additionalHeader : HTTPHeaders = [:],
                               isShowErrorAlerts : Bool = true,
                               Success successBlock:@escaping APIResponseBlock,
                               Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            let header : HTTPHeaders = additionalHeader
            
            if ServiceManager.checkInterNet() {
                
                if isShowLoader {
                    DispatchQueue.main.async {
                        SHOW_CUSTOM_LOADER()
                    }
                }
                
                let url = try getFullUrl(relPath: ApiURL + strURLAdd)
                
                // printing headers and parametes
                printStart(header: header, Parameter: parameters, url: url)
                               
                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseData(completionHandler: { (resObj) in
                    
                    if isShowLoader {
                        DispatchQueue.main.async {
                            HIDE_CUSTOM_LOADER()
                        }
                    }
                    
                    self.printSucess(strUrl: "\(url)", json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0
                    
                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                        
                        self.handleSucess(json: json, statusCode: statusCode, strUrl: "\(url)", isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                        
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }
                        
                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, strUrl: "\(url)", Success: successBlock, Failure: failureBlock)
                    }
                })
            }
            
        } catch let error {
            self.jprint(items: error)
            if isShowLoader {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                }
            }
        }
    }
  
    
    
    struct MultiPartDataType {
        var mimetype: String  = "image/png"
        var fileName: String  = "swift.png"
        var fileData: Data?
        var keyName: String = ""
    }
    
    func postMultipartRequest(ApiURL : ApiURL ,
                              imageVideoParameters : [MultiPartDataType],
                              parameters : [String: Any] ,
                              isShowLoader : Bool = true,
                              isPassHeader : Bool = true,
                              isShowErrorAlerts : Bool = true,
                              Success successBlock:@escaping APIResponseBlock,
                              Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {
                if isShowLoader {
                    DispatchQueue.main.async {
                        SHOW_CUSTOM_LOADER()
                    }
                }
                
                let url = try getFullUrl(relPath: ApiURL.strURL())
                
                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.headers = header
                
                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)
                
                _ = manager.upload(multipartFormData: { multiPart in
                    for (key, value) in parameters {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key )
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                print("keyObj:",keyObj)
                                if let string = element as? String {
                                    print("string:",string)
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    print("num:",num)
                                    
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }else if let temp = value as? Double {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                        }
                        
                    }
                    
                    for obj in imageVideoParameters {
                        if let fileData = obj.fileData {
                            multiPart.append(fileData, withName: obj.keyName, fileName: obj.fileName, mimeType: obj.mimetype)
                        }
                    }
                    
                }, with: urlRequest)
                
                    .uploadProgress(queue: .main, closure: { progress in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    .responseData(completionHandler: { (resObj) in
                        
                        if isShowLoader {
                            DispatchQueue.main.async {
                                HIDE_CUSTOM_LOADER()
                            }
                        }
                        
                        self.printSucess(strUrl: "\(url)", json: resObj)
                        
                        let statusCode = resObj.response?.statusCode ?? 0
                        
                        switch resObj.result {
                        case .success(let json) :
                            print("SuccessJSON \(json)")
                            
                            self.handleSucess(json: json, statusCode: statusCode, strUrl: "\(url)", isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                            
                        case .failure(let err) :
                            print(err)
                            
                            if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                print("Server Error: " + str)
                            }
                            
                            self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, strUrl: "\(url)", Success: successBlock, Failure: failureBlock)
                        }
                        
                    })
            }
            
        }catch let error {
            self.jprint(items: error)
            if isShowLoader {
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                }
            }
        }
    }
    
}


// MARK: - Internet Availability

extension ServiceManager {
    
    class func checkInterNet() -> Bool {
        if Connectivity.isConnectedToInternet() {
            return true
        } else {
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    // Get Full URL
    func getFullUrl(relPath : String) throws -> URL {
        do {
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www") {
                return try relPath.asURL()
            } else {
                return try (ApiURL.baseURL.strURL() + relPath).asURL()
            }
        } catch let err {
            HIDE_CUSTOM_LOADER()
            throw err
        }
    }
}

// MARK:- Handler functions
extension ServiceManager {
    
    func handleSucess(json : Any,isStringJSON : Bool = false, statusCode : Int, strUrl : String, isLoadData: Bool = false, isShowErrorAlerts : Bool = true, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
        
        var jsonResponse = JSON(json)
        if isStringJSON {
            jsonResponse = JSON.init(parseJSON: "\(json)")
        }
        let dataResponce:Dictionary<String,Any> = jsonResponse.dictionaryValue
        let errorMessage : String = jsonResponse["message"].string ?? "Something went wrong."
        
        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage.localizedCaseInsensitiveContains("no record found")))
        
        HIDE_CUSTOM_LOADER()

        if(statusCode == 307)
        {
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            guard isShowErrorAlerts else { return }
            
            if let LIveURL:String = dataResponce["iOS_live_application_url"] as? String{
                if let topController = UIApplication.topViewController2() {
                    
                    showAlertWithTitleFromVC(vc: topController, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Open Store"]) { (i) in
                        if let url = URL(string: LIveURL),
                           UIApplication.shared.canOpenURL(url){
                            guard let url = URL(string: "\(url)"), !url.absoluteString.isEmpty else {
                                return
                            }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        else if(statusCode == 401) && isLoadData == false
        {
            failureBlock(jsonResponse,false,"Something went wrong.", statusCode)
            print(strUrl)
            guard isShowErrorAlerts else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                CurrentUser.shared.clear()
                //showAlertWithTitleFromVC(vc: UIApplication.topViewController2()!, title: Bundle.main.appName, andMessage: errorMessage, buttons: ["OKAY"]) { index in
                    //if index == 0 {
                        appDelegate.setLoginRoot()
                    //}
                //}
            }
            return
        }
        
        else if (statusCode == 412) {
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            guard isShowErrorAlerts else { return }
            
            GeneralUtility.sharedInstance.showErrorMessage(message: errorMessage)
            return
        }
        
        else if (statusCode == 200){
            successBlock(jsonResponse, true, errorMessage,statusCode)
        }
        
        else {
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            guard isShowErrorAlerts else { return }
            
            GeneralUtility.sharedInstance.showErrorMessage(message: errorMessage)
            return
        }
    }
    
    func handleFailure(json : Any, isStringJSON : Bool = false, error : AFError, statusCode : Int, isShowErrorAlerts : Bool = true, strUrl : String, Success suceessBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
        
        var jsonResponse = JSON(json)
        if isStringJSON {
            jsonResponse = JSON.init(parseJSON: "\(json)")
        }
        
        let errorMessage : String = jsonResponse["message"].string ?? "Something went wrong."
        
        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage.localizedCaseInsensitiveContains("no record found")))
        
        print(error.localizedDescription)
        print("\n\n===========Error===========")
        print("URL: \(strUrl)")
        print("Error Code: \(error._code)")
        print("Error Messsage: \(error.localizedDescription)")
        
        //        debugprint(error as Any)
        print("===========================\n\n")
        HIDE_CUSTOM_LOADER()
        
        
        if (error._code == NSURLErrorTimedOut || error._code == 13 ) {
            failureBlock(jsonResponse,true,errorMessage, statusCode)
        }
        else {
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            //showing alert
            guard isShowErrorAlerts else { return }
            
            GeneralUtility.sharedInstance.showErrorMessage(message: errorMessage)
            return
        }
    }
    
    func printStart(header: HTTPHeaders, Parameter: [String : Any] , url: URL)  {
        print("**** API CAll Start ****")
        print("**** API URL ****", url)
        
        print("**** API Header Start ****")
        print(header)
        print("**** API Header End ****")
        print("**** API Parameter Start ****")
        print(Parameter)
        print("**** API Parameter End ****")
    }
    
    func printSucess(strUrl : String, json: Any) {
        print("**** API CAll END ****")
        print("**** API Response Start ****")
        print("**** API Response End ****")
        print(strUrl)

    }
    
    func jprint(items: Any...) {
        for item in items {
            print(item)
        }
    }
}

//public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    #if DEBUG
//    if ServiceManager.shared.isPrintResponse {
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(output, terminator: terminator)
//    }
//    #else
//    #endif
//}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

struct BodyStringEncoding: ParameterEncoding {

    private let body: String

    init(body: String) { self.body = body }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .emptyURLRequest: return "Empty url request"
            case .encodingProblem: return "Encoding problem"
        }
    }
}


func jsonStringSorted(from dictionary: [String: Any]) -> String? {
    // Sort keys alphabetically
    let sortedKeys = dictionary.keys.sorted()
    var jsonPairs: [String] = []
    for key in sortedKeys {
        let value = dictionary[key]!
        let valueString: String
        if let str = value as? String {
            valueString = "\"\(str)\""
        } else {
            valueString = "\(value)"
        }
        jsonPairs.append("\"\(key)\":\(valueString)")
    }
    return "{\(jsonPairs.joined(separator: ","))}"
}
