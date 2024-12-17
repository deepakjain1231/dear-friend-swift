//
//  HomeContentData.swift
//  Dear Friends
//
//  Created by DREAMWORLD on 19/10/24.
//

import Foundation
import SwiftyJSON

import Foundation
import SwiftyJSON

public class SubCategoryModel {
    
    // MARK: - String constants
    private let kSubCategoryIdKey: String = "id"
    private let kSubCategoryCategoriesIDKey: String = "categories_id"
    private let kSubCategoryTitleKey: String = "title"
    private let kSubCategoryIconKey: String = "icon"
    private let kSubCategoryImageKey: String = "image"
    private let kSubCategoryInfoKey: String = "info"
    
    // MARK: - Properties
    public var id: Int?
    public var categoriesID: Int?
    public var title: String?
    public var icon: String?
    public var image: String?
    public var info: String?
    
    // MARK: - Initializer
    public init(json: JSON) {
        id = json[kSubCategoryIdKey].int
        categoriesID = json[kSubCategoryCategoriesIDKey].int
        title = json[kSubCategoryTitleKey].string
        icon = json[kSubCategoryIconKey].string
        image = json[kSubCategoryImageKey].string
        info = json[kSubCategoryInfoKey].string
    }
}

public class CategoryModel {
    
    // MARK: - String constants
    private let kCategoryIdKey: String = "id"
    private let kCategoryTitleKey: String = "title"
    private let kCategoryImageKey: String = "image"
    private let kCategoryStatusKey: String = "status"
    private let kCategoryIsInstrumentalSoundKey: String = "is_instrumental_sound"
    
    // MARK: - Properties
    public var id: Int?
    public var title: String?
    public var image: String?
    public var status: String?
    public var isInstrumentalSound: Bool?
    
    // MARK: - Initializer
    public init(json: JSON) {
        id = json[kCategoryIdKey].int
        title = json[kCategoryTitleKey].string
        image = json[kCategoryImageKey].string
        status = json[kCategoryStatusKey].string
        isInstrumentalSound = json[kCategoryIsInstrumentalSoundKey].bool
    }
}

public class HomeAudioModel {
    
    // MARK: - String constants
    private let kAudioIdKey: String = "id"
    private let kAudioTitleKey: String = "title"
    private let kAudioImageKey: String = "image"
    private let kAudioFileKey: String = "file"
    private let kAudioFemaleAudioKey: String = "female_audio"
    private let kAudioFemaleAudioDurationKey: String = "female_audio_duration"
    private let kAudioDurationKey: String = "audio_duration"
    private let kAudioForKey: String = "for"
    private let kAudioForBeginnerKey: String = "for_beginner"
    private let kAudioTopPicksKey: String = "top_picks"
    private let kAudioIsBackgroundAudioKey: String = "is_background_audio"
    private let kAudioSequenceKey: String = "sequence"
    private let kAudioBackgroundAudiosKey: String = "background_audios"
    private let kAudioNarratedByKey: String = "narrated_by"
    private let kAudioStatusKey: String = "status"
    private let kAudioCreatedAtKey: String = "created_at"
    private let kAudioUpdatedAtKey: String = "updated_at"
    private let kAudioHomeIdKey: String = "home_id"
    private let kAudioAudioIdKey: String = "audio_id"
    private let kAudioCategoryKey: String = "category"
    private let kAudioSubCategoryKey: String = "sub_category"
    
    // MARK: - Properties
    public var id: Int?
    public var title: String?
    public var image: String?
    public var file: String?
    public var femaleAudio: String?
    public var femaleAudioDuration: Double?
    public var audioDuration: Double?
    public var forAccess: String?
    public var forBeginner: Bool?
    public var topPicks: Bool?
    public var isBackgroundAudio: Bool?
    public var sequence: Int?
    public var backgroundAudios: [String]?
    public var narratedBy: String?
    public var status: String?
    public var createdAt: String?
    public var updatedAt: String?
    public var homeId: Int?
    public var audioId: Int?
    public var category: CategoryModel?
    public var subCategory: SubCategoryModel?
    
    // MARK: - Initializer
    public init(json: JSON) {
        id = json[kAudioIdKey].int
        title = json[kAudioTitleKey].string
        image = json[kAudioImageKey].string
        file = json[kAudioFileKey].string
        femaleAudio = json[kAudioFemaleAudioKey].string
        femaleAudioDuration = json[kAudioFemaleAudioDurationKey].double
        audioDuration = json[kAudioDurationKey].double
        forAccess = json[kAudioForKey].string
        forBeginner = json[kAudioForBeginnerKey].bool
        topPicks = json[kAudioTopPicksKey].bool
        isBackgroundAudio = json[kAudioIsBackgroundAudioKey].bool
        sequence = json[kAudioSequenceKey].int
        backgroundAudios = json[kAudioBackgroundAudiosKey].arrayObject as? [String]
        narratedBy = json[kAudioNarratedByKey].string
        status = json[kAudioStatusKey].string
        createdAt = json[kAudioCreatedAtKey].string
        updatedAt = json[kAudioUpdatedAtKey].string
        homeId = json[kAudioHomeIdKey].int
        audioId = json[kAudioAudioIdKey].int
        category = CategoryModel(json: json[kAudioCategoryKey])
        subCategory = SubCategoryModel(json: json[kAudioSubCategoryKey])
    }
}

public class HomeDynamicModel {
    
    // MARK: - String constants
    private let kIdKey = "id"
    private let kNameKey = "name"
    private let kDescriptionKey = "description"
    private let kImageKey = "image"
    private let kStatusKey = "status"
    private let kCreatedAtKey = "created_at"
    private let kUpdatedAtKey = "updated_at"
    private let kDataKey: String = "data"
    
    // MARK: - Properties
    public var id: Int?
    public var name: String?
    public var description: String?
    public var image: String?
    public var status: String?
    public var createdAt: String?
    public var updatedAt: String?
    public var data: [CommonAudioList]?
    
    // MARK: - Initializer
    public init(json: JSON) {
        id = json[kIdKey].int
        name = json[kNameKey].string
        description = json[kDescriptionKey].string
        image = json[kImageKey].string
        status = json[kStatusKey].string
        createdAt = json[kCreatedAtKey].string
        updatedAt = json[kUpdatedAtKey].string
        name = json[kNameKey].string
        if let dataArray = json[kDataKey].array {
            data = dataArray.map { CommonAudioList(json: $0) }
        } else {
            data = []
        }
    }
}
