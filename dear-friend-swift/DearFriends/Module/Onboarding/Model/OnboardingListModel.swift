//
//  OnboardingListModel.swift
//
//  Created by Harsh Doshi on 28/06/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class OnboardingListModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kOnboardingListModelStatusKey: String = "status"
  private let kOnboardingListModelUpdatedAtKey: String = "updated_at"
  private let kOnboardingListModelInternalIdentifierKey: String = "id"
  private let kOnboardingListModelImageKey: String = "image"
  private let kOnboardingListModelCreatedAtKey: String = "created_at"
  private let kOnboardingListModelDescriptionValueKey: String = "description"
  private let kOnboardingListModelTitleKey: String = "title"

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
    status = json[kOnboardingListModelStatusKey].string
    updatedAt = json[kOnboardingListModelUpdatedAtKey].string
    internalIdentifier = json[kOnboardingListModelInternalIdentifierKey].int
    image = json[kOnboardingListModelImageKey].string
    createdAt = json[kOnboardingListModelCreatedAtKey].string
    descriptionValue = json[kOnboardingListModelDescriptionValueKey].string
    title = json[kOnboardingListModelTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kOnboardingListModelStatusKey] = value }
    if let value = updatedAt { dictionary[kOnboardingListModelUpdatedAtKey] = value }
    if let value = internalIdentifier { dictionary[kOnboardingListModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kOnboardingListModelImageKey] = value }
    if let value = createdAt { dictionary[kOnboardingListModelCreatedAtKey] = value }
    if let value = descriptionValue { dictionary[kOnboardingListModelDescriptionValueKey] = value }
    if let value = title { dictionary[kOnboardingListModelTitleKey] = value }
    return dictionary
  }

}




//MARK: - About Creator Model
public class OnboardingAboutCreatorModel {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kOnboardingAboutCreatorModelAboutKey: String = "about"
    private let kOnboardingAboutCreatorModelAudioDurationKey: String = "audio_duration"
    private let kOnboardingAboutCreatorModelCreatedAtKey: String = "created_at"
    private let kOnboardingAboutCreatorModelInternalIdentifierKey: String = "id"
    private let kOnboardingAboutCreatorModelFileKey: String = "file"
    private let kOnboardingAboutCreatorModelUpdatedAtKey: String = "updated_at"
    private let kOnboardingAboutCreatorModelTitleKey: String = "title"

  // MARK: Properties
    public var about: String?
    public var audio_duration: Int?
    public var createdAt: String?
    public var internalIdentifier: Int?
    public var file: String?
    public var updated_at: String?
    public var title: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any?) {
      self.init(json: JSON(object ?? nil))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON?) {
      about = json?[kOnboardingAboutCreatorModelAboutKey].string
      updated_at = json?[kOnboardingAboutCreatorModelUpdatedAtKey].string
      internalIdentifier = json?[kOnboardingAboutCreatorModelInternalIdentifierKey].int
      file = json?[kOnboardingAboutCreatorModelFileKey].string
      createdAt = json?[kOnboardingAboutCreatorModelCreatedAtKey].string
      audio_duration = json?[kOnboardingAboutCreatorModelAudioDurationKey].int
      title = json?[kOnboardingAboutCreatorModelTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
      if let value = about { dictionary[kOnboardingAboutCreatorModelAboutKey] = value }
      if let value = updated_at { dictionary[kOnboardingAboutCreatorModelUpdatedAtKey] = value }
      if let value = internalIdentifier { dictionary[kOnboardingAboutCreatorModelInternalIdentifierKey] = value }
      if let value = file { dictionary[kOnboardingAboutCreatorModelFileKey] = value }
      if let value = createdAt { dictionary[kOnboardingAboutCreatorModelCreatedAtKey] = value }
      if let value = audio_duration { dictionary[kOnboardingAboutCreatorModelAudioDurationKey] = value }
      if let value = title { dictionary[kOnboardingAboutCreatorModelTitleKey] = value }
    return dictionary
  }

}
