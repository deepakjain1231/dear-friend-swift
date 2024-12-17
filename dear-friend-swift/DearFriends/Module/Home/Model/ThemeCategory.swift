//
//  File.swift
//  Dear Friends
//
//  Created by Jigar Khatri on 29/11/24.
//

import Foundation
import SwiftyJSON

public class ThemeCategory {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kSubCategoryTitleKey: String = "title"
    private let kSubCategoryCategoriesIdKey: String = "categories_id"
    private let kCategorySubCategoryKey: String = "sub_categories"
    private let kSubCategoryInternalIdentifierKey: String = "id"
    private let kSubCategoryImageKey: String = "image"
    
    // MARK: Properties
    public var title: String?
    public var categoriesId: Int?
    public var internalIdentifier: Int?
    public var subCategory: [SubCategory]?
    public var image: String?
    public var info: String?
    var isSelect = false
    var icon: String?
    
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
        title = json[kSubCategoryTitleKey].string
        categoriesId = json[kSubCategoryCategoriesIdKey].int
        internalIdentifier = json[kSubCategoryInternalIdentifierKey].int
        image = json[kSubCategoryImageKey].string
        info = json["info"].string
        icon = json["icon"].string
        if let items = json[kCategorySubCategoryKey].array { subCategory = items.map { SubCategory(json: $0) } }

    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[kSubCategoryTitleKey] = value }
        if let value = categoriesId { dictionary[kSubCategoryCategoriesIdKey] = value }
        if let value = internalIdentifier { dictionary[kSubCategoryInternalIdentifierKey] = value }
        if let value = image { dictionary[kSubCategoryImageKey] = value }
        if let value = subCategory { dictionary[kCategorySubCategoryKey] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}
