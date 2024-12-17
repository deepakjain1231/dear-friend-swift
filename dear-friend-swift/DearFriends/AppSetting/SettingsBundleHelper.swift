//
//  SettingsBundleHelper.swift
//  DearFriends
//
//  Created by Himanshu Visroliya on 29/05/23.
//

import Foundation

class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let AppVersionKey = "version_preference"
    }
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            // reset userDefaults..
            // CoreDataDataModel().deleteAllData()
            // delete all other user data here..
        }
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        UserDefaults.standard.set("\(version) (\(build))", forKey: "version_preference")
    }
}
