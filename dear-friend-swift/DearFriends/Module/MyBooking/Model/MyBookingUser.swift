//
//  MyBookingUser.swift
//
//  Created by Harsh Doshi on 13/12/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class MyBookingUser {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMyBookingUserProfileImageKey: String = "profile_image"
  private let kMyBookingUserAutoRenewalKey: String = "auto_renewal"
  private let kMyBookingUserTypeKey: String = "type"
  private let kMyBookingUserLastNameKey: String = "last_name"
  private let kMyBookingUserCountryCodeKey: String = "country_code"
  private let kMyBookingUserPreferencesKey: String = "preferences"
  private let kMyBookingUserInternalIdentifierKey: String = "id"
  private let kMyBookingUserNameKey: String = "name"
  private let kMyBookingUserResetTokenKey: String = "reset_token"
  private let kMyBookingUserUpdatedAtKey: String = "updated_at"
  private let kMyBookingUserEmailKey: String = "email"
  private let kMyBookingUserMobileKey: String = "mobile"
  private let kMyBookingUserStatusKey: String = "status"
  private let kMyBookingUserCountryIso2CodeKey: String = "country_iso2_code"
  private let kMyBookingUserPremiumKey: String = "premium"
  private let kMyBookingUserCreatedAtKey: String = "created_at"
  private let kMyBookingUserFirstNameKey: String = "first_name"

  // MARK: Properties
  public var profileImage: String?
  public var autoRenewal: String?
  public var type: String?
  public var lastName: String?
  public var countryCode: String?
  public var preferences: [Any]?
  public var internalIdentifier: Int?
  public var name: String?
  public var resetToken: String?
  public var updatedAt: String?
  public var email: String?
  public var mobile: String?
  public var status: String?
  public var countryIso2Code: String?
  public var premium: Int?
  public var createdAt: String?
  public var firstName: String?
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
    profileImage = json[kMyBookingUserProfileImageKey].string
    autoRenewal = json[kMyBookingUserAutoRenewalKey].string
    type = json[kMyBookingUserTypeKey].string
    lastName = json[kMyBookingUserLastNameKey].string
    countryCode = json[kMyBookingUserCountryCodeKey].string
    if let items = json[kMyBookingUserPreferencesKey].array { preferences = items.map { $0.object} }
    internalIdentifier = json[kMyBookingUserInternalIdentifierKey].int
    name = json[kMyBookingUserNameKey].string
    resetToken = json[kMyBookingUserResetTokenKey].string
    updatedAt = json[kMyBookingUserUpdatedAtKey].string
    email = json[kMyBookingUserEmailKey].string
    mobile = json[kMyBookingUserMobileKey].string
    status = json[kMyBookingUserStatusKey].string
    countryIso2Code = json[kMyBookingUserCountryIso2CodeKey].string
    premium = json[kMyBookingUserPremiumKey].int
    createdAt = json[kMyBookingUserCreatedAtKey].string
    firstName = json[kMyBookingUserFirstNameKey].string
      title = json["title"].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profileImage { dictionary[kMyBookingUserProfileImageKey] = value }
    if let value = autoRenewal { dictionary[kMyBookingUserAutoRenewalKey] = value }
    if let value = type { dictionary[kMyBookingUserTypeKey] = value }
    if let value = lastName { dictionary[kMyBookingUserLastNameKey] = value }
    if let value = countryCode { dictionary[kMyBookingUserCountryCodeKey] = value }
    if let value = preferences { dictionary[kMyBookingUserPreferencesKey] = value }
    if let value = internalIdentifier { dictionary[kMyBookingUserInternalIdentifierKey] = value }
    if let value = name { dictionary[kMyBookingUserNameKey] = value }
    if let value = resetToken { dictionary[kMyBookingUserResetTokenKey] = value }
    if let value = updatedAt { dictionary[kMyBookingUserUpdatedAtKey] = value }
    if let value = email { dictionary[kMyBookingUserEmailKey] = value }
    if let value = mobile { dictionary[kMyBookingUserMobileKey] = value }
    if let value = status { dictionary[kMyBookingUserStatusKey] = value }
    if let value = countryIso2Code { dictionary[kMyBookingUserCountryIso2CodeKey] = value }
    if let value = premium { dictionary[kMyBookingUserPremiumKey] = value }
    if let value = createdAt { dictionary[kMyBookingUserCreatedAtKey] = value }
    if let value = firstName { dictionary[kMyBookingUserFirstNameKey] = value }
    return dictionary
  }

}
