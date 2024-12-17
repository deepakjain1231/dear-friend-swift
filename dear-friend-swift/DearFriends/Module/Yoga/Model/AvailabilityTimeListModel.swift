//
//  AvailabilityTimeListModel.swift
//
//  Created by Harsh Doshi on 08/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class AvailabilityTimeListModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAvailabilityTimeListModelStartTimeKey: String = "start_time"
  private let kAvailabilityTimeListModelEndTimeKey: String = "end_time"
  private let kAvailabilityTimeListModelIsAvailableKey: String = "is_available"

  // MARK: Properties
  public var startTime: String?
  public var endTime: String?
  public var isAvailable: Int?

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
    startTime = json[kAvailabilityTimeListModelStartTimeKey].string
    endTime = json[kAvailabilityTimeListModelEndTimeKey].string
    isAvailable = json[kAvailabilityTimeListModelIsAvailableKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = startTime { dictionary[kAvailabilityTimeListModelStartTimeKey] = value }
    if let value = endTime { dictionary[kAvailabilityTimeListModelEndTimeKey] = value }
    if let value = isAvailable { dictionary[kAvailabilityTimeListModelIsAvailableKey] = value }
    return dictionary
  }

}
