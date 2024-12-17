//
//  AuthContent.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 19/10/24.
//

import Foundation
import SwiftyJSON

public class AuthContentModel {
    
    // MARK: - Declaration for string constants used to decode and serialize.
    private let kAuthScreenModelImageKey: String = "image"
    private let kAuthScreenModelTitleKey: String = "title"
    private let kAuthScreenModelCreatedAtKey: String = "created_at"
    private let kAuthScreenModelSlugKey: String = "slug"
    private let kAuthScreenModelUpdatedAtKey: String = "updated_at"
    private let kAuthScreenModelStatusKey: String = "status"
    private let kAuthScreenModelDescriptionKey: String = "description"
    private let kAuthScreenModelIdKey: String = "id"
    
    // MARK: - Properties
    public var image: String?
    public var title: String?
    public var createdAt: String?
    public var slug: String?
    public var updatedAt: String?
    public var status: String?
    public var descriptionValue: String?
    public var id: Int?
    
    // MARK: - SwiftyJSON Initializers
    /**
     Initializes the instance based on the JSON object.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initialized instance of the class.
     */
    public init(json: JSON) {
        image = json[kAuthScreenModelImageKey].string
        title = json[kAuthScreenModelTitleKey].string
        createdAt = json[kAuthScreenModelCreatedAtKey].string
        slug = json[kAuthScreenModelSlugKey].string
        updatedAt = json[kAuthScreenModelUpdatedAtKey].string
        status = json[kAuthScreenModelStatusKey].string
        descriptionValue = json[kAuthScreenModelDescriptionKey].string
        id = json[kAuthScreenModelIdKey].int
    }
    
    /**
     Generates a dictionary representation of the object.
     - returns: A dictionary containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = image { dictionary[kAuthScreenModelImageKey] = value }
        if let value = title { dictionary[kAuthScreenModelTitleKey] = value }
        if let value = createdAt { dictionary[kAuthScreenModelCreatedAtKey] = value }
        if let value = slug { dictionary[kAuthScreenModelSlugKey] = value }
        if let value = updatedAt { dictionary[kAuthScreenModelUpdatedAtKey] = value }
        if let value = status { dictionary[kAuthScreenModelStatusKey] = value }
        if let value = descriptionValue { dictionary[kAuthScreenModelDescriptionKey] = value }
        if let value = id { dictionary[kAuthScreenModelIdKey] = value }
        return dictionary
    }
    
    // Convenience initializer to handle any object
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
}
