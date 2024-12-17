//
//  MyBookingInstructor.swift
//
//  Created by Harsh Doshi on 13/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MyBookingInstructor {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMyBookingInstructorProfileImageKey: String = "profile_image"
  private let kMyBookingInstructorAutoRenewalKey: String = "auto_renewal"
  private let kMyBookingInstructorTypeKey: String = "type"
  private let kMyBookingInstructorPreferencesKey: String = "preferences"
  private let kMyBookingInstructorInternalIdentifierKey: String = "id"
  private let kMyBookingInstructorSessionKey: String = "session"
  private let kMyBookingInstructorTitleKey: String = "title"
  private let kMyBookingInstructorAboutInstructorKey: String = "about_instructor"
  private let kMyBookingInstructorNameKey: String = "name"
  private let kMyBookingInstructorUpdatedAtKey: String = "updated_at"
  private let kMyBookingInstructorEmailKey: String = "email"
  private let kMyBookingInstructorMobileKey: String = "mobile"
  private let kMyBookingInstructorSessionPriceKey: String = "session_price"
  private let kMyBookingInstructorUsernameKey: String = "username"
  private let kMyBookingInstructorStatusKey: String = "status"
  private let kMyBookingInstructorCategoryIdsKey: String = "category_ids"
  private let kMyBookingInstructorPremiumKey: String = "premium"
  private let kMyBookingInstructorCreatedAtKey: String = "created_at"

  // MARK: Properties
  public var profileImage: String?
  public var autoRenewal: String?
  public var type: String?
  public var preferences: [Any]?
  public var internalIdentifier: Int?
  public var session: Int?
  public var title: String?
  public var aboutInstructor: String?
  public var name: String?
  public var updatedAt: String?
  public var email: String?
  public var mobile: String?
  public var sessionPrice: Int?
  public var username: String?
  public var status: String?
  public var categoryIds: String?
  public var premium: Int?
  public var createdAt: String?

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
    profileImage = json[kMyBookingInstructorProfileImageKey].string
    autoRenewal = json[kMyBookingInstructorAutoRenewalKey].string
    type = json[kMyBookingInstructorTypeKey].string
    if let items = json[kMyBookingInstructorPreferencesKey].array { preferences = items.map { $0.object} }
    internalIdentifier = json[kMyBookingInstructorInternalIdentifierKey].int
    session = json[kMyBookingInstructorSessionKey].int
    title = json[kMyBookingInstructorTitleKey].string
    aboutInstructor = json[kMyBookingInstructorAboutInstructorKey].string
    name = json[kMyBookingInstructorNameKey].string
    updatedAt = json[kMyBookingInstructorUpdatedAtKey].string
    email = json[kMyBookingInstructorEmailKey].string
    mobile = json[kMyBookingInstructorMobileKey].string
    sessionPrice = json[kMyBookingInstructorSessionPriceKey].int
    username = json[kMyBookingInstructorUsernameKey].string
    status = json[kMyBookingInstructorStatusKey].string
    categoryIds = json[kMyBookingInstructorCategoryIdsKey].string
    premium = json[kMyBookingInstructorPremiumKey].int
    createdAt = json[kMyBookingInstructorCreatedAtKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profileImage { dictionary[kMyBookingInstructorProfileImageKey] = value }
    if let value = autoRenewal { dictionary[kMyBookingInstructorAutoRenewalKey] = value }
    if let value = type { dictionary[kMyBookingInstructorTypeKey] = value }
    if let value = preferences { dictionary[kMyBookingInstructorPreferencesKey] = value }
    if let value = internalIdentifier { dictionary[kMyBookingInstructorInternalIdentifierKey] = value }
    if let value = session { dictionary[kMyBookingInstructorSessionKey] = value }
    if let value = title { dictionary[kMyBookingInstructorTitleKey] = value }
    if let value = aboutInstructor { dictionary[kMyBookingInstructorAboutInstructorKey] = value }
    if let value = name { dictionary[kMyBookingInstructorNameKey] = value }
    if let value = updatedAt { dictionary[kMyBookingInstructorUpdatedAtKey] = value }
    if let value = email { dictionary[kMyBookingInstructorEmailKey] = value }
    if let value = mobile { dictionary[kMyBookingInstructorMobileKey] = value }
    if let value = sessionPrice { dictionary[kMyBookingInstructorSessionPriceKey] = value }
    if let value = username { dictionary[kMyBookingInstructorUsernameKey] = value }
    if let value = status { dictionary[kMyBookingInstructorStatusKey] = value }
    if let value = categoryIds { dictionary[kMyBookingInstructorCategoryIdsKey] = value }
    if let value = premium { dictionary[kMyBookingInstructorPremiumKey] = value }
    if let value = createdAt { dictionary[kMyBookingInstructorCreatedAtKey] = value }
    return dictionary
  }

}
