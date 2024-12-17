//
//  BookingViewModel.swift
//  DearFriends
//
//  Created by Harsh Doshi on 13/12/23.
//

import Foundation
import SwiftyJSON

class BookingViewModel {
    
    var arrOfUpcomingBooking = [MyBookingListModel]()
    var limitForUpcoming = 10
    var offsetForUpcoming = 0
    var hasMoreDataForUpcoming = false
    var isAPICallingForUpcoming = false
    
    var arrOfCompletedBooking = [MyBookingListModel]()
    var limitForBooking = 10
    var offsetForBooking = 0
    var hasMoreDataForBooking = false
    var isAPICallingForBooking = false
    
    var currentBooking: MyBookingListModel?
    
    var status = ""
}

// MARK: - Get Video Screen Data

extension BookingViewModel {
    
    func getBookingList(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params = [:] as [String : Any]
        
        if self.status == "pending" {
            params = ["status": self.status,
                      "limit": self.limitForUpcoming,
                      "offset": self.offsetForUpcoming]
        } else {
            params = ["status": self.status,
                      "limit": self.limitForBooking,
                      "offset": self.offsetForBooking]
        }
        
        ServiceManager.shared.postRequest(ApiURL: .myBooking, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                let arr = response["data"].arrayValue
                
                if self.status == "pending" {
                    if self.offsetForUpcoming == 0 {
                        self.arrOfUpcomingBooking.removeAll()
                    }
                    arr.forEach { modeel in
                        self.arrOfUpcomingBooking.append(MyBookingListModel(json: modeel))
                    }
                    self.hasMoreDataForUpcoming = arr.count >= 10
                    self.isAPICallingForUpcoming = false
                    
                } else {
                    if self.offsetForBooking == 0 {
                        self.arrOfCompletedBooking.removeAll()
                    }
                    arr.forEach { modeel in
                        self.arrOfCompletedBooking.append(MyBookingListModel(json: modeel))
                    }
                    self.hasMoreDataForBooking = arr.count >= 10
                    self.isAPICallingForBooking = false
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
    
    func getBookingDetails(id: String, isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        var params = [:] as [String : Any]
        
        params = ["id": id]
        
        ServiceManager.shared.postRequest(ApiURL: .bookingdetail, parameters: params, isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            if isSuccess == true {
                
                self.currentBooking = MyBookingListModel(json: response["data"])
                
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
