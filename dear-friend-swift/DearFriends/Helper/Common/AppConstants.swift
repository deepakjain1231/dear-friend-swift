//
//  AppConstants.swift
//  ChillsQatarCustomer
//
//  Created by M1 Mac mini 4 on 05/08/22.
//

import Foundation
import UIKit

// Currency
let appCurrency: String = "$"
let smallAppCurrency: String = "$"

// Setup Keys
var GoogleFCMServerKey = "AAAAiWI9UdY:APA91bHGSkimW92d-OyjaDrb3pqqgrwZ0t2HhQkB3n6yzb3KzLPWKGhIY9D2qE0W4pPyNiouW83Y4Tzm3JeiTQHIZiOEJEGuAvp-aDWkxpvqT1hDV4EFWmnN2dHuDi5vbyp9nsVA-CO_"
var stripeSecreteKey = "sk_test_51OMPz2JmiMLsTYtwsWsabJWrjUCfelotLFDAOvMfIjOu6bMkeoQnvfQckvOALQo56FKqzJL0xSVFb911gwExjAWa009sUCjqVA"
var stripePublishKey = "pk_test_51OMPz2JmiMLsTYtw7ahjaNBZ5OdlHIzT7YJebt6DKYsAM0AjQ5yE7yq3qmppmptkVG6sPPvlaCmMK2SWsTKlOlkD00VJKx0lGv"

// UIImages
let placeholderImage : UIImage? = UIImage(named: "ic_placeholder")

// Text strings
let strNo = "no"
let strYes = "yes"
let strGuidedBy = "Guided By - "

enum ContactSupport: String, CaseIterable {
    case giveFeedback = "Give General Feedback"
    case generalQuestions = "General Questions"
    case reportBug = "Report a Bug"
    case paymentIssues = "Payment Issues"
    case suggestFeature = "Suggest a Feature"
    case suggestMeditation = "Suggest a Meditation"

    // Optional: A function to return the display name of each case
    var displayName: String {
        return self.rawValue
    }
}

let lastPromptKey = "lastPromptDate"
let maxPromptCountKey = "maxPromptCount"
let maxPromptCount = 7
let userRatedApp = "userRatedApp"


let lastPreferenceDate = "lastPreferenceDate"
let updatePreferences = "updatePreferences"

let lastAudioIdKey = "lastAudioId"
let lastProgressKey = "lastProgress"
let biometricsEnable = "biometricsEnable"
let lastPlanPurchsed = "LastPlanPurchsed"

let intro_showcase_1 = "intro_showcase_1"
let intro_showcase_lastKey = "intro_showcase_lastKey"
let intro_showcase_maxPromptKey = "intro_showcase_maxPromptKey"
let intro_showcase_maxPromptCount = 7

let lastShowcaseDate = "lastShowcaseDate"
let updateShowcase = "updateShowcase"

// Success Messages
struct SuccessMessage {
    static let successContactSupport = "Thanks for reaching out, If your message requires a response, we'll get back to you ASAP"
}
