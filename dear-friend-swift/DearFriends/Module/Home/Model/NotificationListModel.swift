//
//  NotificationListModel.swift
//
//  Created by Harsh Doshi on 26/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class NotificationListModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNotificationListModelFromUserIdKey: String = "from_user_id"
    private let kNotificationListModelPushTypeKey: String = "push_type"
    private let kNotificationListModelInternalIdentifierKey: String = "id"
    private let kNotificationListModelObjectIdKey: String = "object_id"
    private let kNotificationListModelUpdatedAtKey: String = "updated_at"
    private let kNotificationListModelCreatedAtKey: String = "created_at"
    private let kNotificationListModelPushTitleKey: String = "push_title"
    private let kNotificationListModelUserIdKey: String = "user_id"
    private let kNotificationListModelPushMessageKey: String = "push_message"
    private let kNotificationListModelFileKey: String = "image"

    // MARK: Properties
    public var fromUserId: Int?
    public var pushType: Int?
    public var internalIdentifier: Int?
    public var objectId: Int?
    public var updatedAt: String?
    public var createdAt: String?
    public var pushTitle: String?
    public var userId: Int?
    public var pushMessage: String?
    public var file: String?
    var read = 0
    
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
        fromUserId = json[kNotificationListModelFromUserIdKey].int
        pushType = json[kNotificationListModelPushTypeKey].int
        internalIdentifier = json[kNotificationListModelInternalIdentifierKey].int
        objectId = json[kNotificationListModelObjectIdKey].int
        updatedAt = json[kNotificationListModelUpdatedAtKey].string
        createdAt = json[kNotificationListModelCreatedAtKey].string
        pushTitle = json[kNotificationListModelPushTitleKey].string
        userId = json[kNotificationListModelUserIdKey].int
        pushMessage = json[kNotificationListModelPushMessageKey].string
        file = json[kNotificationListModelFileKey].string
        read = json["read"].intValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = fromUserId { dictionary[kNotificationListModelFromUserIdKey] = value }
        if let value = pushType { dictionary[kNotificationListModelPushTypeKey] = value }
        if let value = internalIdentifier { dictionary[kNotificationListModelInternalIdentifierKey] = value }
        if let value = objectId { dictionary[kNotificationListModelObjectIdKey] = value }
        if let value = updatedAt { dictionary[kNotificationListModelUpdatedAtKey] = value }
        if let value = createdAt { dictionary[kNotificationListModelCreatedAtKey] = value }
        if let value = pushTitle { dictionary[kNotificationListModelPushTitleKey] = value }
        if let value = userId { dictionary[kNotificationListModelUserIdKey] = value }
        if let value = pushMessage { dictionary[kNotificationListModelPushMessageKey] = value }
        if let value = file { dictionary[kNotificationListModelFileKey] = value }
        return dictionary
    }
    
}
