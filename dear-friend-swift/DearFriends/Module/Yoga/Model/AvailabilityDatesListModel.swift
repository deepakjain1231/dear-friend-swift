//
//  AvailabilityDatesListModel.swift
//
//  Created by Harsh Doshi on 08/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class AvailabilityDatesListModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kAvailabilityDatesListModelDateKey: String = "date"
    private let kAvailabilityDatesListModelIsOpenKey: String = "is_open"
    
    // MARK: Properties
    public var date: String?
    public var isOpen: Int?
    
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
        date = json[kAvailabilityDatesListModelDateKey].stringValue
        isOpen = json[kAvailabilityDatesListModelIsOpenKey].intValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = date { dictionary[kAvailabilityDatesListModelDateKey] = value }
        if let value = isOpen { dictionary[kAvailabilityDatesListModelIsOpenKey] = value }
        return dictionary
    }
    
}
