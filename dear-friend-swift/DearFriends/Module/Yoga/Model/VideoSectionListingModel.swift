//
//  VideoSectionListingModel.swift
//
//  Created by Harsh Doshi on 20/11/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class VideoSectionListingModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kVideoSectionListingModelStatusKey: String = "status"
    private let kVideoSectionListingModelNameKey: String = "name"
    private let kVideoSectionListingModelEmailKey: String = "email"
    private let kVideoSectionListingModelInternalIdentifierKey: String = "id"
    private let kVideoSectionListingModelMobileKey: String = "mobile"
    private let kVideoSectionListingModelCreatedAtKey: String = "created_at"
    private let kVideoSectionListingModelVideoKey: String = "video"
    private let kVideoSectionListingModelProfileImageKey: String = "profile_image"
    private let kVideoSectionListingModelUsernameKey: String = "username"
    
    // MARK: Properties
    public var status: String?
    public var name: String?
    public var email: String?
    public var internalIdentifier: Int?
    public var mobile: String?
    public var createdAt: String?
    public var video: [VideoSectionVideo]?
    public var profileImage: String?
    public var username: String?
    var title: String?
    var about_instructor: String?
    var session_price: String?
    var session = 0
    
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
        status = json[kVideoSectionListingModelStatusKey].string
        name = json[kVideoSectionListingModelNameKey].string
        title = json["title"].stringValue
        about_instructor = json["about_instructor"].stringValue
        session_price = json["session_price"].stringValue
        email = json[kVideoSectionListingModelEmailKey].string
        internalIdentifier = json[kVideoSectionListingModelInternalIdentifierKey].int
        mobile = json[kVideoSectionListingModelMobileKey].string
        createdAt = json[kVideoSectionListingModelCreatedAtKey].string
        if let items = json[kVideoSectionListingModelVideoKey].array { video = items.map { VideoSectionVideo(json: $0) } }
        profileImage = json[kVideoSectionListingModelProfileImageKey].string
        username = json[kVideoSectionListingModelUsernameKey].string
        session = json["session"].intValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = status { dictionary[kVideoSectionListingModelStatusKey] = value }
        if let value = name { dictionary[kVideoSectionListingModelNameKey] = value }
        if let value = email { dictionary[kVideoSectionListingModelEmailKey] = value }
        if let value = internalIdentifier { dictionary[kVideoSectionListingModelInternalIdentifierKey] = value }
        if let value = mobile { dictionary[kVideoSectionListingModelMobileKey] = value }
        if let value = createdAt { dictionary[kVideoSectionListingModelCreatedAtKey] = value }
        if let value = video { dictionary[kVideoSectionListingModelVideoKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = profileImage { dictionary[kVideoSectionListingModelProfileImageKey] = value }
        if let value = username { dictionary[kVideoSectionListingModelUsernameKey] = value }
        return dictionary
    }
    
}
