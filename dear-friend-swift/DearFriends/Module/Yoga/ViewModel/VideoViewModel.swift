//
//  VideoViewModel.swift
//  DearFriends
//
//  Created by Harsh Doshi on 20/11/23.
//

import Foundation
import UIKit
import SwiftyJSON
import Stripe
import Alamofire
import SwiftDate

class VideoViewModel {
 
    var catID = ""
    var limit = 10
    var offset = 0
    var hasMoreData = false
    var isAPICalling = false
    
    var instructor_id = ""
    var bookingID = ""
    var currentBooking: MyBookingListModel?
    var currentInstructorDetails: VideoSectionListingModel?
    
    var arrOfVideosList = [VideoSectionListingModel]()
    
    var start_date = ""
    var end_date = ""
    var arrOfDates = [AvailabilityDatesListModel]()
    
    var selDates = ""
    var booking_time = ""
    var txnID = ""
    var pay_amount = ""
    var arrOfTimes = [AvailabilityTimeListModel]()
    
    var stripeparams: STPCardParams = STPCardParams()
    var paymentToken = ""
    var paymentIntentClientSecret: String?
    var vc = UIViewController()
}

// MARK: - Get Video Screen Data

extension VideoViewModel {
    
    func getVideoList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let params = ["category_id": self.catID,
                      "limit": self.limit,
                      "offset": self.offset] as [String : Any]
        
        ServiceManager.shared.postRequest(ApiURL: .videoList, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                let arr = response["data"].arrayValue
                if self.offset == 0 {
                    self.arrOfVideosList.removeAll()
                }
                arr.forEach { modeel in
                    self.arrOfVideosList.append(VideoSectionListingModel(json: modeel))
                }
                self.hasMoreData = arr.count >= 10
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
    
    func getInstructorVideoDetails(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let params = ["instructor_id": self.instructor_id,
                      "limit": self.limit,
                      "category_id": self.catID,
                      "offset": self.offset] as [String : Any]
        
        ServiceManager.shared.postRequest(ApiURL: .instructor_video_details, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.currentInstructorDetails = VideoSectionListingModel(json: response["data"])
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

extension VideoViewModel {
    
    func getAvailbleDats(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let params = ["start_date": self.start_date,
                      "instructor_id": self.instructor_id,
                      "end_date": self.end_date] as [String : Any]
        
        ServiceManager.shared.postRequest(ApiURL: .instructoravailabilitydates, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfDates.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfDates.append(AvailabilityDatesListModel(json: model))
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

// MARK: - Time Slot Available

extension VideoViewModel {
    
    func getAvailbleTimeSlot(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let params = ["date": self.selDates,
                      "category_id": self.catID,
                      "instructor_id": self.instructor_id] as [String : Any]
        
        ServiceManager.shared.postRequest(ApiURL: .instructoravailabilitytimeslot, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                self.arrOfTimes.removeAll()
                response["data"].arrayValue.forEach { model in
                    self.arrOfTimes.append(AvailabilityTimeListModel(json: model))
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
    
    func bookVideo(isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params = ["booking_date": self.selDates,
                      "booking_time": self.booking_time,
                      "category_id": self.catID,
                      "instructor_id": self.instructor_id] as [String : Any]
        
        if self.bookingID != "" {
            params["id"] = self.bookingID
            params["transaction_id"] = self.currentBooking?.transactionId ?? ""
            params["pay_amount"] = "\(self.currentBooking?.payAmount ?? 0)"
        } else {
            params["transaction_id"] = self.txnID
            params["pay_amount"] = self.currentInstructorDetails?.session_price ?? ""
        }
        
        ServiceManager.shared.postRequest(ApiURL: .bookVideo, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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
    
    func payForCustomChat(custom_audio_request_id: String, 
                          total_amount: String,
                          payment_status: String,
                          sub_total: String,
                          charge: String,
                          isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params = [:] as [String : Any]
        
        if (CurrentUser.shared.user?.is_free_custom_audios ?? "") == "1" {
            params = ["custom_audio_request_id": custom_audio_request_id,
                      "total_amount": "0",
                      "currency": "USD",
                      "sub_total": "0",
                      "charge": "0",
                      "payment_status": payment_status]
            
        } else {
            params = ["custom_audio_request_id": custom_audio_request_id,
                          "total_amount": total_amount,
                          "currency": "USD",
                          "sub_total": sub_total,
                          "charge": charge,
                          "transaction_id": self.txnID,
                          "payment_status": payment_status]
        }
        
        ServiceManager.shared.postRequest(ApiURL: .payForCustom, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
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

// MARK: - For Stripe Related Functions

extension VideoViewModel {
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
        
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        return stringWithAddedSpaces
    }
    
    func checkCardNumberisValid(cardNumber: String) -> Bool {
        
        stripeparams.number = cardNumber
        
        let validationStateForCard: STPCardValidationState = STPCardValidator.validationState(forNumber: stripeparams.number, validatingCardBrand: false)
        var msg: String = ""
        
        if validationStateForCard == STPCardValidationState.invalid || validationStateForCard == STPCardValidationState.incomplete {
            
            if validationStateForCard == STPCardValidationState.invalid {
                msg = "card number is invalid."
                
            } else {
                msg = "card number is incomplete."
            }
            GeneralUtility().showErrorMessage(message: msg)
            return false
            
        } else {
            return true
        }
    }
    
    func checkCardExpDateisValid(expMonth: String, andExpirationYear expYear: String) -> Bool {
        
        var validationStateForCard = STPCardValidator.validationState(forExpirationMonth: "\(expMonth)")
        var msg: String = ""
        
        if validationStateForCard == STPCardValidationState.invalid || validationStateForCard == STPCardValidationState.incomplete {
            
            msg = "Expiration month is invalid."
            
            GeneralUtility().showErrorMessage(message: msg)
            
            return false
            
        } else {
            
            validationStateForCard =   STPCardValidator.validationState(forExpirationYear: "\(expYear)", inMonth: "\(expMonth)")
            
            if validationStateForCard == STPCardValidationState.invalid || validationStateForCard == STPCardValidationState.incomplete {
                
                msg = "Expiration Year is invalid."
                
                GeneralUtility().showErrorMessage(message: msg)
                
                return false
                
            } else {
                return true
            }
        }
    }
    
    func checkCardCVVisValid(cvc: String) -> Bool {
        
        stripeparams.cvc = cvc
        
        let stpcardbrand: STPCardBrand = STPCardValidator.brand(forNumber: stripeparams.number!)
        let validationStateForCard =   STPCardValidator.validationState(forCVC: cvc, cardBrand: stpcardbrand)
        var msg = ""
        
        if validationStateForCard == STPCardValidationState.invalid || validationStateForCard == STPCardValidationState.incomplete {
            
            msg = "CVV is incomplete."
            
            GeneralUtility().showErrorMessage(message: msg)
            return false
            
        } else {
            return true
        }
    }
    
    func createPaymentIntent(amount: String, isShowLoader: Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(stripeSecreteKey)"]
        let finalPrice = ((Double(amount) ?? 0) * 100).rounded()
        ServiceManager.shared.postRequestForStipe(ApiURL: "https://api.stripe.com/v1/payment_intents", parameters: ["amount": Int(finalPrice), "currency": "usd"], isShowLoader: isShowLoader, additionalHeader: header) { (response, Success, message, statusCode) in
            print("Success Response:", response)
            if Success == true {
                self.paymentIntentClientSecret = response["client_secret"].stringValue
                self.txnID = response["id"].stringValue
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { (response, Success, message, statusCode) in
            print("Failure Response:", response)
            failure(response)
        }
    }
}
