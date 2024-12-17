//
//  HomeDataModel.swift
//
//  Created by Himanshu Visroliya on 30/05/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class HomeDataModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHomeDataModelBeginnerPathKey: String = "beginner_path"
  private let kHomeDataModelTopPicksKey: String = "top_picks"
  private let kHomeDataModelRecommendedKey: String = "recommended"
  private let kHomeDataModelCategoryKey: String = "category"

  // MARK: Properties
  public var beginnerPath: [CommonAudioList]?
  public var topPicks: [CommonAudioList]?
  public var recommended: [CommonAudioList]?
  public var category: [Category]?

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
    if let items = json[kHomeDataModelBeginnerPathKey].array { beginnerPath = items.map { CommonAudioList(json: $0) } }
    if let items = json[kHomeDataModelTopPicksKey].array { topPicks = items.map { CommonAudioList(json: $0) } }
    if let items = json[kHomeDataModelRecommendedKey].array { recommended = items.map { CommonAudioList(json: $0) } }
    if let items = json[kHomeDataModelCategoryKey].array { category = items.map { Category(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = beginnerPath { dictionary[kHomeDataModelBeginnerPathKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = topPicks { dictionary[kHomeDataModelTopPicksKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = recommended { dictionary[kHomeDataModelRecommendedKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = category { dictionary[kHomeDataModelCategoryKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
