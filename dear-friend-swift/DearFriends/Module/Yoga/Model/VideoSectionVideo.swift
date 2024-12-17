//
//  VideoSectionVideo.swift
//
//  Created by Harsh Doshi on 20/11/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class VideoSectionVideo {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kVideoSectionVideoStatusKey: String = "status"
    private let kVideoSectionVideoInstructorIdKey: String = "instructor_id"
    private let kVideoSectionVideoUpdatedAtKey: String = "updated_at"
    private let kVideoSectionVideoInternalIdentifierKey: String = "id"
    private let kVideoSectionVideoImageKey: String = "image"
    private let kVideoSectionVideoVideoLinkKey: String = "video_link"
    private let kVideoSectionVideoCreatedAtKey: String = "created_at"
    private let kVideoSectionVideoCategoryIdKey: String = "category_id"
    private let kVideoSectionVideoTitleKey: String = "title"
    private let kVideoSectionVideoAccessTypeKey: String = "access_type"
    
    // MARK: Properties
    public var status: String?
    public var instructorId: Int?
    public var updatedAt: String?
    public var internalIdentifier: Int?
    public var image: String?
    public var videoLink: String?
    public var createdAt: String?
    public var categoryId: Int?
    public var title: String?
    public var accessType: String?
    var video_duration: String?
    var video_id: String?
    
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
        status = json[kVideoSectionVideoStatusKey].string
        instructorId = json[kVideoSectionVideoInstructorIdKey].int
        updatedAt = json[kVideoSectionVideoUpdatedAtKey].string
        internalIdentifier = json[kVideoSectionVideoInternalIdentifierKey].int
        image = json[kVideoSectionVideoImageKey].string
        videoLink = json[kVideoSectionVideoVideoLinkKey].string
        createdAt = json[kVideoSectionVideoCreatedAtKey].string
        categoryId = json[kVideoSectionVideoCategoryIdKey].int
        title = json[kVideoSectionVideoTitleKey].string
        accessType = json[kVideoSectionVideoAccessTypeKey].string
        video_duration = json["video_duration"].stringValue
        video_id = json["video_id"].stringValue
        
//        video_duration = "\((self.video_duration?.doubleValue ?? 0) * 60.0)"
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = status { dictionary[kVideoSectionVideoStatusKey] = value }
        if let value = instructorId { dictionary[kVideoSectionVideoInstructorIdKey] = value }
        if let value = updatedAt { dictionary[kVideoSectionVideoUpdatedAtKey] = value }
        if let value = internalIdentifier { dictionary[kVideoSectionVideoInternalIdentifierKey] = value }
        if let value = image { dictionary[kVideoSectionVideoImageKey] = value }
        if let value = videoLink { dictionary[kVideoSectionVideoVideoLinkKey] = value }
        if let value = createdAt { dictionary[kVideoSectionVideoCreatedAtKey] = value }
        if let value = categoryId { dictionary[kVideoSectionVideoCategoryIdKey] = value }
        if let value = title { dictionary[kVideoSectionVideoTitleKey] = value }
        if let value = accessType { dictionary[kVideoSectionVideoAccessTypeKey] = value }
        return dictionary
    }
    
}
