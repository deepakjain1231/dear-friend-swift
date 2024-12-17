//
//  ChatMessageListingModel.swift
//
//  Created by Harsh Doshi on 27/11/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class ChatMessageListingModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kChatMessageListingModelUpdatedAtKey: String = "updated_at"
    private let kChatMessageListingModelReceiverIdKey: String = "receiver_id"
    private let kChatMessageListingModelFileKey: String = "file"
    private let kChatMessageListingModelTypeKey: String = "type"
    private let kChatMessageListingModelThreadsIdKey: String = "threads_id"
    private let kChatMessageListingModelSenderStatusKey: String = "sender_status"
    private let kChatMessageListingModelSenderIdKey: String = "sender_id"
    private let kChatMessageListingModelStatusKey: String = "status"
    private let kChatMessageListingModelInternalIdentifierKey: String = "id"
    private let kChatMessageListingModelCreatedAtKey: String = "created_at"
    private let kChatMessageListingModelReceiverStatusKey: String = "receiver_status"
    private let kChatMessageListingModelMessageKey: String = "message"
    private let kChatMessageListingModelDeletedAtKey: String = "deleted_at"
    
    // MARK: Properties
    public var updatedAt: String?
    public var receiverId: Int?
    public var file: String?
    public var type: String?
    public var threadsId: Int?
    public var senderStatus: String?
    public var senderId: Int?
    public var status: String?
    public var internalIdentifier: Int?
    public var createdAt: String?
    public var receiverStatus: String?
    public var message: String?
    public var deletedAt: String?
    var isSending = false
    var audio_duration: String?
    
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
        updatedAt = json[kChatMessageListingModelUpdatedAtKey].string
        receiverId = json[kChatMessageListingModelReceiverIdKey].int
        file = json[kChatMessageListingModelFileKey].string
        type = json[kChatMessageListingModelTypeKey].string
        threadsId = json[kChatMessageListingModelThreadsIdKey].int
        senderStatus = json[kChatMessageListingModelSenderStatusKey].string
        senderId = json[kChatMessageListingModelSenderIdKey].int
        status = json[kChatMessageListingModelStatusKey].string
        internalIdentifier = json[kChatMessageListingModelInternalIdentifierKey].int
        createdAt = json[kChatMessageListingModelCreatedAtKey].string
        receiverStatus = json[kChatMessageListingModelReceiverStatusKey].string
        message = json[kChatMessageListingModelMessageKey].string
        deletedAt = json[kChatMessageListingModelDeletedAtKey].string
        audio_duration = json["audio_duration"].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = updatedAt { dictionary[kChatMessageListingModelUpdatedAtKey] = value }
        if let value = receiverId { dictionary[kChatMessageListingModelReceiverIdKey] = value }
        if let value = file { dictionary[kChatMessageListingModelFileKey] = value }
        if let value = type { dictionary[kChatMessageListingModelTypeKey] = value }
        if let value = threadsId { dictionary[kChatMessageListingModelThreadsIdKey] = value }
        if let value = senderStatus { dictionary[kChatMessageListingModelSenderStatusKey] = value }
        if let value = senderId { dictionary[kChatMessageListingModelSenderIdKey] = value }
        if let value = status { dictionary[kChatMessageListingModelStatusKey] = value }
        if let value = internalIdentifier { dictionary[kChatMessageListingModelInternalIdentifierKey] = value }
        if let value = createdAt { dictionary[kChatMessageListingModelCreatedAtKey] = value }
        if let value = receiverStatus { dictionary[kChatMessageListingModelReceiverStatusKey] = value }
        if let value = message { dictionary[kChatMessageListingModelMessageKey] = value }
        if let value = deletedAt { dictionary[kChatMessageListingModelDeletedAtKey] = value }
        return dictionary
    }
    
}
