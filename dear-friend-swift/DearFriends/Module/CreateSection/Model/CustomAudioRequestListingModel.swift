//
//  CustomAudioRequestListingModel.swift
//
//  Created by Harsh Doshi on 18/11/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CustomAudioRequestListingModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCustomAudioRequestListingModelFormatKey: String = "format"
    private let kCustomAudioRequestListingModelUpdatedAtKey: String = "updated_at"
    private let kCustomAudioRequestListingModelRequestStatusKey: String = "request_status"
    private let kCustomAudioRequestListingModelGoalsAndChallengesKey: String = "goals_and_challenges"
    private let kCustomAudioRequestListingModelStatusKey: String = "status"
    private let kCustomAudioRequestListingModelInternalIdentifierKey: String = "id"
    private let kCustomAudioRequestListingModelMeditationNameKey: String = "meditation_name"
    private let kCustomAudioRequestListingModelVoiceIdKey: String = "voice_id"
    private let kCustomAudioRequestListingModelCreatedAtKey: String = "created_at"
    private let kCustomAudioRequestListingModelPauseDurationKey: String = "pause_duration"
    private let kCustomAudioRequestListingModelUserIdKey: String = "user_id"
    private let kCustomAudioRequestListingModelScriptKey: String = "script"
    
    // MARK: Properties
    public var format: String?
    public var updatedAt: String?
    public var requestStatus: String?
    public var goalsAndChallenges: String?
    public var status: String?
    public var internalIdentifier: Int?
    public var meditationName: String?
    public var voiceId: Int?
    public var createdAt: String?
    public var pauseDuration: String?
    public var userId: Int?
    public var script: String?
    var edit_custom_audio_request_count: Int?
    var isDownloaded = false
    var audio_file = ""
    var audio_duration = ""
    var is_chat_open: Int?
    
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
        format = json[kCustomAudioRequestListingModelFormatKey].string
        audio_file = json["audio_file"].stringValue
        audio_duration = json["audio_duration"].stringValue
        edit_custom_audio_request_count = json["edit_custom_audio_request_count"].intValue
        updatedAt = json[kCustomAudioRequestListingModelUpdatedAtKey].string
        requestStatus = json[kCustomAudioRequestListingModelRequestStatusKey].string
        goalsAndChallenges = json[kCustomAudioRequestListingModelGoalsAndChallengesKey].string
        status = json[kCustomAudioRequestListingModelStatusKey].string
        internalIdentifier = json[kCustomAudioRequestListingModelInternalIdentifierKey].int
        meditationName = json[kCustomAudioRequestListingModelMeditationNameKey].string
        voiceId = json[kCustomAudioRequestListingModelVoiceIdKey].int
        createdAt = json[kCustomAudioRequestListingModelCreatedAtKey].string
        pauseDuration = json[kCustomAudioRequestListingModelPauseDurationKey].string
        userId = json[kCustomAudioRequestListingModelUserIdKey].int
        script = json[kCustomAudioRequestListingModelScriptKey].string
        is_chat_open = json["is_chat_open"].intValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = format { dictionary[kCustomAudioRequestListingModelFormatKey] = value }
        if let value = updatedAt { dictionary[kCustomAudioRequestListingModelUpdatedAtKey] = value }
        if let value = requestStatus { dictionary[kCustomAudioRequestListingModelRequestStatusKey] = value }
        if let value = goalsAndChallenges { dictionary[kCustomAudioRequestListingModelGoalsAndChallengesKey] = value }
        if let value = status { dictionary[kCustomAudioRequestListingModelStatusKey] = value }
        if let value = internalIdentifier { dictionary[kCustomAudioRequestListingModelInternalIdentifierKey] = value }
        if let value = meditationName { dictionary[kCustomAudioRequestListingModelMeditationNameKey] = value }
        if let value = voiceId { dictionary[kCustomAudioRequestListingModelVoiceIdKey] = value }
        if let value = createdAt { dictionary[kCustomAudioRequestListingModelCreatedAtKey] = value }
        if let value = pauseDuration { dictionary[kCustomAudioRequestListingModelPauseDurationKey] = value }
        if let value = userId { dictionary[kCustomAudioRequestListingModelUserIdKey] = value }
        if let value = script { dictionary[kCustomAudioRequestListingModelScriptKey] = value }
        return dictionary
    }
    
}
