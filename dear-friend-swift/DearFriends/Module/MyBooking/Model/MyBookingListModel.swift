//
//  MyBookingListModel.swift
//
//  Created by Harsh Doshi on 13/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MyBookingListModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kMyBookingListModelPayAmountKey: String = "pay_amount"
    private let kMyBookingListModelUserKey: String = "user"
    private let kMyBookingListModelUpdatedAtKey: String = "updated_at"
    private let kMyBookingListModelTransactionIdKey: String = "transaction_id"
    private let kMyBookingListModelInstructorIdKey: String = "instructor_id"
    private let kMyBookingListModelBookingTimeKey: String = "booking_time"
    private let kMyBookingListModelInternalIdentifierKey: String = "id"
    private let kMyBookingListModelPaymentMethodKey: String = "payment_method"
    private let kMyBookingListModelBookingDateKey: String = "booking_date"
    private let kMyBookingListModelCreatedAtKey: String = "created_at"
    private let kMyBookingListModelStatusKey: String = "status"
    private let kMyBookingListModelUserIdKey: String = "user_id"
    private let kMyBookingListModelInstructorKey: String = "instructor"
    
    // MARK: Properties
    public var payAmount: Double?
    public var user: MyBookingUser?
    public var updatedAt: String?
    public var transactionId: String?
    public var instructorId: Int?
    public var bookingTime: String?
    public var internalIdentifier: Int?
    public var paymentMethod: String?
    public var bookingDate: String?
    public var createdAt: String?
    public var status: String?
    public var userId: Int?
    public var instructor: MyBookingInstructor?
    var meeting_link = ""
    var receiptLink = ""
    var reschedule_counter = 0
    var bookingHistory: BookingHistoryModel?
    
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
        payAmount = json[kMyBookingListModelPayAmountKey].doubleValue.roundedValues(toPlaces: 2)
        user = MyBookingUser(json: json[kMyBookingListModelUserKey])
        updatedAt = json[kMyBookingListModelUpdatedAtKey].string
        transactionId = json[kMyBookingListModelTransactionIdKey].string
        reschedule_counter = json["reschedule_counter"].intValue
        instructorId = json[kMyBookingListModelInstructorIdKey].int
        bookingTime = json[kMyBookingListModelBookingTimeKey].string
        internalIdentifier = json[kMyBookingListModelInternalIdentifierKey].int
        paymentMethod = json[kMyBookingListModelPaymentMethodKey].string
        bookingDate = json[kMyBookingListModelBookingDateKey].string
        createdAt = json[kMyBookingListModelCreatedAtKey].string
        status = json[kMyBookingListModelStatusKey].string
        meeting_link = json["meeting_link"].stringValue
        receiptLink = json["receipt"].stringValue
        userId = json[kMyBookingListModelUserIdKey].int
        instructor = MyBookingInstructor(json: json[kMyBookingListModelInstructorKey])
        self.bookingHistory = BookingHistoryModel(json: json["booking_history"])
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = payAmount { dictionary[kMyBookingListModelPayAmountKey] = value }
        if let value = user { dictionary[kMyBookingListModelUserKey] = value.dictionaryRepresentation() }
        if let value = updatedAt { dictionary[kMyBookingListModelUpdatedAtKey] = value }
        if let value = transactionId { dictionary[kMyBookingListModelTransactionIdKey] = value }
        if let value = instructorId { dictionary[kMyBookingListModelInstructorIdKey] = value }
        if let value = bookingTime { dictionary[kMyBookingListModelBookingTimeKey] = value }
        if let value = internalIdentifier { dictionary[kMyBookingListModelInternalIdentifierKey] = value }
        if let value = paymentMethod { dictionary[kMyBookingListModelPaymentMethodKey] = value }
        if let value = bookingDate { dictionary[kMyBookingListModelBookingDateKey] = value }
        if let value = createdAt { dictionary[kMyBookingListModelCreatedAtKey] = value }
        if let value = status { dictionary[kMyBookingListModelStatusKey] = value }
        if let value = userId { dictionary[kMyBookingListModelUserIdKey] = value }
        if let value = instructor { dictionary[kMyBookingListModelInstructorKey] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}

public class BookingHistoryModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBookingHistoryModelBookingIdKey: String = "booking_id"
    private let kBookingHistoryModelBookingTimeKey: String = "booking_time"
    private let kBookingHistoryModelBookingDateKey: String = "booking_date"
    private let kBookingHistoryModelInstructorIdKey: String = "instructor_id"
    private let kBookingHistoryModelPayAmountKey: String = "pay_amount"
    private let kBookingHistoryModelInternalIdentifierKey: String = "id"
    private let kBookingHistoryModelUpdatedAtKey: String = "updated_at"
    private let kBookingHistoryModelCreatedAtKey: String = "created_at"
    private let kBookingHistoryModelMeetingLinkKey: String = "meeting_link"
    private let kBookingHistoryModelPaymentMethodKey: String = "payment_method"
    private let kBookingHistoryModelUserIdKey: String = "user_id"
    
    // MARK: Properties
    public var bookingId: Int?
    public var bookingTime: String?
    public var bookingDate: String?
    public var instructorId: Int?
    public var payAmount: Double?
    public var internalIdentifier: Int?
    public var updatedAt: String?
    public var createdAt: String?
    public var meetingLink: String?
    public var paymentMethod: String?
    public var userId: Int?
    
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
        bookingId = json[kBookingHistoryModelBookingIdKey].int
        bookingTime = json[kBookingHistoryModelBookingTimeKey].string
        bookingDate = json[kBookingHistoryModelBookingDateKey].string
        instructorId = json[kBookingHistoryModelInstructorIdKey].int
        payAmount = json[kBookingHistoryModelPayAmountKey].double
        internalIdentifier = json[kBookingHistoryModelInternalIdentifierKey].int
        updatedAt = json[kBookingHistoryModelUpdatedAtKey].string
        createdAt = json[kBookingHistoryModelCreatedAtKey].string
        meetingLink = json[kBookingHistoryModelMeetingLinkKey].string
        paymentMethod = json[kBookingHistoryModelPaymentMethodKey].string
        userId = json[kBookingHistoryModelUserIdKey].int
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = bookingId { dictionary[kBookingHistoryModelBookingIdKey] = value }
        if let value = bookingTime { dictionary[kBookingHistoryModelBookingTimeKey] = value }
        if let value = bookingDate { dictionary[kBookingHistoryModelBookingDateKey] = value }
        if let value = instructorId { dictionary[kBookingHistoryModelInstructorIdKey] = value }
        if let value = payAmount { dictionary[kBookingHistoryModelPayAmountKey] = value }
        if let value = internalIdentifier { dictionary[kBookingHistoryModelInternalIdentifierKey] = value }
        if let value = updatedAt { dictionary[kBookingHistoryModelUpdatedAtKey] = value }
        if let value = createdAt { dictionary[kBookingHistoryModelCreatedAtKey] = value }
        if let value = meetingLink { dictionary[kBookingHistoryModelMeetingLinkKey] = value }
        if let value = paymentMethod { dictionary[kBookingHistoryModelPaymentMethodKey] = value }
        if let value = userId { dictionary[kBookingHistoryModelUserIdKey] = value }
        return dictionary
    }
    
}
