//
//  Backgrounds.swift
//
//  Created by Himanshu Visroliya on 30/05/23
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class BackgroundsList: NSObject, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and serialize.
    private let kBackgroundsInternalIdentifierKey: String = "background_audio_id"
    private let kBackgroundsAudioIdKey: String = "audio_id"
    private let kBackgroundsFileKey: String = "file"
    private let kBackgroundsTitleKey: String = "title"
    private let kBackgroundsTypeKey: String = "type"
    private let kBackgroundsIsDefaultKey: String = "is_default"
    
    // MARK: Properties
    public var internalIdentifier: Int?
    public var audioId: Int?
    public var file: String?
    public var title: String?
    public var type: String?
    public var isDefault: Int?
    var isShow = true
    
    // MARK: Initializers
    public init(internalIdentifier: Int?, audioId: Int?, file: String?, title: String?, type: String?, isDefault: Int?) {
        self.internalIdentifier = internalIdentifier
        self.audioId = audioId
        self.file = file
        self.title = title
        self.type = type
        self.isDefault = isDefault
    }
    
    public init(json: JSON) {
        internalIdentifier = json[kBackgroundsInternalIdentifierKey].int
        file = json[kBackgroundsFileKey].string
        title = json[kBackgroundsTitleKey].string
        type = json[kBackgroundsTypeKey].string
        isDefault = json[kBackgroundsIsDefaultKey].int
        audioId = json[kBackgroundsAudioIdKey].int
    }
    
    // MARK: - NSCoding
    public func encode(with coder: NSCoder) {
        coder.encode(internalIdentifier, forKey: kBackgroundsInternalIdentifierKey)
        coder.encode(audioId, forKey: kBackgroundsAudioIdKey)
        coder.encode(file, forKey: kBackgroundsFileKey)
        coder.encode(title, forKey: kBackgroundsTitleKey)
        coder.encode(type, forKey: kBackgroundsTypeKey)
        coder.encode(isDefault, forKey: kBackgroundsIsDefaultKey)
    }
    
    public required convenience init?(coder: NSCoder) {
        let internalIdentifier = coder.decodeObject(forKey: "background_audio_id") as? Int
        let audioId = coder.decodeObject(forKey: "audio_id") as? Int
        let file = coder.decodeObject(forKey: "file") as? String
        let title = coder.decodeObject(forKey: "title") as? String
        let type = coder.decodeObject(forKey: "type") as? String
        let isDefault = coder.decodeObject(forKey: "is_default") as? Int
        self.init(internalIdentifier: internalIdentifier, audioId: audioId, file: file, title: title, type: type, isDefault: isDefault)
    }
}
