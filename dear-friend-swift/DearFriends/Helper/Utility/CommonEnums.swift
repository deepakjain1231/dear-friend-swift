//
//  CommonEnums.swift
//  Tipitapp
//
//  Created by M1 Mac Mini 2 on 02/05/22.
//

import Foundation

enum RandomUserSize: Float {
    case remove = 0
    case lowest = 48 // 4 - 5
    case low = 52 // 3 - 4
    case medium = 56 // 2 - 3
    case high = 60 // 1 - 2
    case highest = 84 // < 1
}

enum UserType: String {
    case receiverType = "0"
    case senderType = "1"
}

enum GradientDirection {
    case Right
    case Left
    case Bottom
    case Top
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}


enum Mixpanel_Event: String {
    case MeditationStart = "meditation_start"
    case MeditationEnd = "meditation_end"
    case AppOpen = "app_open"
    case SessionStart = "session_start"
    case SignUp = "signup"
    case UpgradePremium = "upgrade_to_premium"
    case CancelPremium = "cancel_to_premium"
    case MeditationPlay = "meditation_play"
    case MeditaionFavorite = "meditation_favorited"
}
