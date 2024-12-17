//
//  SampleAudioList.swift
//
//  Created by Harsh Doshi on 09/11/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SampleAudioList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kSampleAudioListStatusKey: String = "status"
    private let kSampleAudioListUpdatedAtKey: String = "updated_at"
    private let kSampleAudioListInternalIdentifierKey: String = "id"
    private let kSampleAudioListCreatedAtKey: String = "created_at"
    private let kSampleAudioListGenderKey: String = "gender"
    private let kSampleAudioListTitleKey: String = "title"
    private let kSampleAudioListFileKey: String = "file"
    
    // MARK: Properties
    public var status: String?
    public var updatedAt: String?
    public var internalIdentifier: Int?
    public var createdAt: String?
    public var gender: String?
    public var title: String?
    public var file: String?
    
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
        status = json[kSampleAudioListStatusKey].string
        updatedAt = json[kSampleAudioListUpdatedAtKey].string
        internalIdentifier = json[kSampleAudioListInternalIdentifierKey].int
        createdAt = json[kSampleAudioListCreatedAtKey].string
        gender = json[kSampleAudioListGenderKey].string
        title = json[kSampleAudioListTitleKey].string
        file = json[kSampleAudioListFileKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = status { dictionary[kSampleAudioListStatusKey] = value }
        if let value = updatedAt { dictionary[kSampleAudioListUpdatedAtKey] = value }
        if let value = internalIdentifier { dictionary[kSampleAudioListInternalIdentifierKey] = value }
        if let value = createdAt { dictionary[kSampleAudioListCreatedAtKey] = value }
        if let value = gender { dictionary[kSampleAudioListGenderKey] = value }
        if let value = title { dictionary[kSampleAudioListTitleKey] = value }
        if let value = file { dictionary[kSampleAudioListFileKey] = value }
        return dictionary
    }
    
}
