//
//  Category.swift
//
//  Created by Himanshu Visroliya on 30/05/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Category {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCategoryTitleKey: String = "title"
    private let kCategoryThemeCategoryKey: String = "theme_categories"
    private let kCategorySubCategoryKey: String = "sub_category"
    private let kCategoryInternalIdentifierKey: String = "id"
    private let kCategoryImageKey: String = "image"
    
    // MARK: Properties
    public var title: String?
    public var themeCategory: [ThemeCategory]?
    public var subCategory: [SubCategory]?
    public var internalIdentifier: Int?
    public var image: String?
    var isSelect = false
    var access_type: String?
    
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
        title = json[kCategoryTitleKey].string
        access_type = json["access_type"].stringValue
        if let items = json[kCategoryThemeCategoryKey].array { themeCategory = items.map { ThemeCategory(json: $0) } }
        if let items = json[kCategorySubCategoryKey].array { subCategory = items.map { SubCategory(json: $0) } }
        internalIdentifier = json[kCategoryInternalIdentifierKey].int
        image = json[kCategoryImageKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[kCategoryTitleKey] = value }
        if let value = themeCategory { dictionary[kCategoryThemeCategoryKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = subCategory { dictionary[kCategorySubCategoryKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = internalIdentifier { dictionary[kCategoryInternalIdentifierKey] = value }
        if let value = image { dictionary[kCategoryImageKey] = value }
        return dictionary
    }
    
}
