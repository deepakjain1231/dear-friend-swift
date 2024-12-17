//
//  HomeContentList.swift
//
//  Created by Harsh Doshi on 26/01/24
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class HomeContentList {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHomeContentListStatusKey: String = "status"
  private let kHomeContentListUpdatedAtKey: String = "updated_at"
  private let kHomeContentListInternalIdentifierKey: String = "id"
  private let kHomeContentListImageKey: String = "image"
  private let kHomeContentListCreatedAtKey: String = "created_at"
  private let kHomeContentListDescriptionValueKey: String = "description"
  private let kHomeContentListTitleKey: String = "title"

  // MARK: Properties
  public var status: String?
  public var updatedAt: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var createdAt: String?
  public var descriptionValue: String?
  public var title: String?

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
    status = json[kHomeContentListStatusKey].string
    updatedAt = json[kHomeContentListUpdatedAtKey].string
    internalIdentifier = json[kHomeContentListInternalIdentifierKey].int
    image = json[kHomeContentListImageKey].string
    createdAt = json[kHomeContentListCreatedAtKey].string
    descriptionValue = json[kHomeContentListDescriptionValueKey].string
    title = json[kHomeContentListTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kHomeContentListStatusKey] = value }
    if let value = updatedAt { dictionary[kHomeContentListUpdatedAtKey] = value }
    if let value = internalIdentifier { dictionary[kHomeContentListInternalIdentifierKey] = value }
    if let value = image { dictionary[kHomeContentListImageKey] = value }
    if let value = createdAt { dictionary[kHomeContentListCreatedAtKey] = value }
    if let value = descriptionValue { dictionary[kHomeContentListDescriptionValueKey] = value }
    if let value = title { dictionary[kHomeContentListTitleKey] = value }
    return dictionary
  }

}
