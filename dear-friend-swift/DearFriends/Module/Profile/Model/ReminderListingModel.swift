//
//  ReminderListingModel.swift
//
//  Created by ZB on 05/06/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ReminderListingModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kReminderListingModelRepeatOnKey: String = "repeat_on"
    private let kReminderListingModelInternalIdentifierKey: String = "id"
    private let kReminderListingModelUpdatedAtKey: String = "updated_at"
    private let kReminderListingModelCreatedAtKey: String = "created_at"
    private let kReminderListingModelTitleKey: String = "title"
    private let kReminderListingModelUserIdKey: String = "user_id"
    private let kReminderListingModelTimeKey: String = "time"
    
    // MARK: Properties
    public var repeatOn: [String]?
    public var internalIdentifier: Int?
    public var updatedAt: String?
    public var createdAt: String?
    public var title: String?
    public var userId: Int?
    public var time: String?
    public var date: String?
    
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
        if let items = json[kReminderListingModelRepeatOnKey].array { repeatOn = items.map { $0.stringValue } }
        internalIdentifier = json[kReminderListingModelInternalIdentifierKey].int
        updatedAt = json[kReminderListingModelUpdatedAtKey].string
        createdAt = json[kReminderListingModelCreatedAtKey].string
        title = json[kReminderListingModelTitleKey].string
        userId = json[kReminderListingModelUserIdKey].int
        time = json[kReminderListingModelTimeKey].string
        date = json["date"].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = repeatOn { dictionary[kReminderListingModelRepeatOnKey] = value }
        if let value = internalIdentifier { dictionary[kReminderListingModelInternalIdentifierKey] = value }
        if let value = updatedAt { dictionary[kReminderListingModelUpdatedAtKey] = value }
        if let value = createdAt { dictionary[kReminderListingModelCreatedAtKey] = value }
        if let value = title { dictionary[kReminderListingModelTitleKey] = value }
        if let value = userId { dictionary[kReminderListingModelUserIdKey] = value }
        if let value = time { dictionary[kReminderListingModelTimeKey] = value }
        return dictionary
    }
    
}
