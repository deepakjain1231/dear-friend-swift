//
//  BGAudioListModel.swift
//
//  Created by Harsh Doshi on 11/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class BGAudioListModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBGAudioListModelInternalIdentifierKey: String = "id"
    private let kBGAudioListModelFileKey: String = "file"
    private let kBGAudioListModelTitleKey: String = "title"
    private let kBGAudioListModelTypeKey: String = "type"

    // MARK: Properties
    public var internalIdentifier: Int?
    public var file: String?
    public var title: String?
    public var type: String?
    var isShow = true
    
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
        internalIdentifier = json[kBGAudioListModelInternalIdentifierKey].int
        file = json[kBGAudioListModelFileKey].string
        title = json[kBGAudioListModelTitleKey].string
        type = json[kBGAudioListModelTypeKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier { dictionary[kBGAudioListModelInternalIdentifierKey] = value }
        if let value = file { dictionary[kBGAudioListModelFileKey] = value }
        if let value = title { dictionary[kBGAudioListModelTitleKey] = value }
        if let value = type { dictionary[kBGAudioListModelTypeKey] = value }
        return dictionary
    }
    
}

extension BGAudioListModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(internalIdentifier)
    }

    public static func == (lhs: BGAudioListModel, rhs: BGAudioListModel) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
