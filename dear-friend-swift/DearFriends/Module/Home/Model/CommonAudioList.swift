//
//  CommonAudioList.swift
//
//  Created by Himanshu Visroliya on 30/05/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CommonAudioList {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRecommendedUpdatedAtKey: String = "updated_at"
    private let kRecommendedBackgroundAudiosKey: String = "background_audios"
    private let kRecommendedAudioDurationKey: String = "audio_duration"
    private let kRecommendedFileKey: String = "file"
    private let kRecommendedCategoryIdKey: String = "category_id"
    private let kRecommendedIsLikedKey: String = "is_liked"
    private let kRecommendedCategoryKey: String = "category"
    private let kRecommendedSubCategoryIdKey: String = "sub_category_id"
    private let kRecommendedStatusKey: String = "status"
    private let kRecommendedSequenceKey: String = "sequence"
    private let kRecommendedInternalIdentifierKey: String = "id"
    private let kRecommendedImageKey: String = "image"
    private let kRecommendedBackgroundsKey: String = "background_audios_list"
    private let kRecommendedCreatedAtKey: String = "created_at"
    private let kRecommendedNarratedByKey: String = "narrated_by"
    private let kRecommendedSubCategoryKey: String = "sub_category"
    private let kRecommendedThemeCategoryKey: String = "theme_category"
    private let kRecommendedTitleKey: String = "title"
    private let kRecommendedAudioWaveformKey: String = "audio_waveform"
    private let kRecommendedDurationKey: String = "duration"
    private let kRecommendedForBeginnerKey: String = "for_beginner"
    private let kRecommendedForKey: String = "for"
    private let kRecommendedAudioProgress: String = "audio_progress"
    
    // MARK: Properties
    public var updatedAt: String?
    public var backgroundAudios: [String]?
    public var audioDuration: String?
    public var file: String?
    public var categoryId: Int?
    public var isLiked: Int?
    public var category: Category?
    public var subCategoryId: Int?
    public var status: String?
    public var sequence: String?
    public var internalIdentifier: Int?
    public var image: String?
    public var backgrounds: [BackgroundsList]?
    public var createdAt: String?
    public var narratedBy: String?
    public var themeCategory: ThemeCategory?
    public var subCategory: SubCategory?
    public var title: String?
    public var audioWaveform: String?
//    public var duration: String?
    public var forBeginner: String?
    public var forSTr: String?
    public var id: Int?
    public var audioProgress: String?
    
    var isDownloaded = false
    var musicURL: URL?
    var feMalemusicURL: URL?
    var femaleAudioStr: String?
    var is_background_audio: String?
    var female_audio_duration: String?
    
    var pin_date: String?
    
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
        updatedAt = json[kRecommendedUpdatedAtKey].string
        if let items = json[kRecommendedBackgroundAudiosKey].array { backgroundAudios = items.map { $0.stringValue } }
        audioDuration = json[kRecommendedAudioDurationKey].stringValue
        file = json[kRecommendedFileKey].string
        femaleAudioStr = json["female_audio"].stringValue
        categoryId = json[kRecommendedCategoryIdKey].int
        isLiked = json[kRecommendedIsLikedKey].int
        category = Category(json: json[kRecommendedCategoryKey])
        subCategoryId = json[kRecommendedSubCategoryIdKey].int
        status = json[kRecommendedStatusKey].string
        sequence = json[kRecommendedSequenceKey].string
        internalIdentifier = json[kRecommendedInternalIdentifierKey].int
        image = json[kRecommendedImageKey].string
        if let items = json[kRecommendedBackgroundsKey].array { backgrounds = items.map { BackgroundsList(json: $0) } }
        createdAt = json[kRecommendedCreatedAtKey].string
        narratedBy = json[kRecommendedNarratedByKey].string
        subCategory = SubCategory(json: json[kRecommendedSubCategoryKey])
        themeCategory = ThemeCategory(json: json[kRecommendedThemeCategoryKey])
        title = json[kRecommendedTitleKey].string
        audioWaveform = json[kRecommendedAudioWaveformKey].string
//        duration = json[kRecommendedDurationKey].string
        forBeginner = json[kRecommendedForBeginnerKey].string
        forSTr = json[kRecommendedForKey].string
        id = json[kRecommendedInternalIdentifierKey].int
        is_background_audio = json["is_background_audio"].stringValue
        female_audio_duration = json["female_audio_duration"].stringValue
        pin_date = json["pin_date"].stringValue
        audioProgress = json[kRecommendedAudioProgress].stringValue
        
        if let urll = URL(string: self.file ?? "") {
            self.musicURL = urll
        }
        
        if let urll2 = URL(string: self.femaleAudioStr ?? "") {
            self.feMalemusicURL = urll2
        }
        
        if json["female_audio_duration"].stringValue != "" {
            self.female_audio_duration = json["female_audio_duration"].stringValue
        }
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = updatedAt { dictionary[kRecommendedUpdatedAtKey] = value }
        if let value = backgroundAudios { dictionary[kRecommendedBackgroundAudiosKey] = value }
        if let value = audioDuration { dictionary[kRecommendedAudioDurationKey] = value }
        if let value = file { dictionary[kRecommendedFileKey] = value }
        if let value = categoryId { dictionary[kRecommendedCategoryIdKey] = value }
        if let value = isLiked { dictionary[kRecommendedIsLikedKey] = value }
        if let value = category { dictionary[kRecommendedCategoryKey] = value.dictionaryRepresentation() }
        if let value = subCategoryId { dictionary[kRecommendedSubCategoryIdKey] = value }
        if let value = status { dictionary[kRecommendedStatusKey] = value }
        if let value = sequence { dictionary[kRecommendedSequenceKey] = value }
        if let value = internalIdentifier { dictionary[kRecommendedInternalIdentifierKey] = value }
        if let value = image { dictionary[kRecommendedImageKey] = value }
        if let value = createdAt { dictionary[kRecommendedCreatedAtKey] = value }
        if let value = narratedBy { dictionary[kRecommendedNarratedByKey] = value }
        if let value = subCategory { dictionary[kRecommendedSubCategoryKey] = value.dictionaryRepresentation() }
        if let value = themeCategory { dictionary[kRecommendedThemeCategoryKey] = value.dictionaryRepresentation() }
        if let value = title { dictionary[kRecommendedTitleKey] = value }
        if let value = audioWaveform { dictionary[kRecommendedAudioWaveformKey] = value }
        if let value = forBeginner { dictionary[kRecommendedForBeginnerKey] = value }
        if let value = forSTr { dictionary[kRecommendedForKey] = value }
        if let value = id { dictionary[kRecommendedInternalIdentifierKey] = value }
        if let value = audioProgress { dictionary[kRecommendedAudioProgress] = value }
        return dictionary
    }
    
}
