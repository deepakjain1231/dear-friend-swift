
import Foundation
import UIKit
// Usage Examples
let SemiBoldS16   = Font(.installed(.SemiBold), size: .standard(.S16)).instance
let SemiBoldS22   = Font(.installed(.SemiBold), size: .standard(.S22)).instance

let Medium16   = Font(.installed(.Medium), size: .standard(.S16)).instance
let Medium20   = Font(.installed(.Medium), size: .standard(.S20)).instance
let SemiBoldS18   = Font(.installed(.SemiBold), size: .standard(.S18)).instance
let RegularS10   = Font(.installed(.Black), size: .standard(.S10)).instance
let RegularS11  = Font(.installed(.Black), size: .standard(.S11)).instance
let RegularS12   = Font(.installed(.Black), size: .standard(.S12)).instance
let RegularS13   = Font(.installed(.Black), size: .standard(.S13)).instance
let RegularS16   = Font(.installed(.Regular), size: .standard(.S16)).instance
let LightS16   = Font(.installed(.Light), size: .standard(.S16)).instance


struct Font {
    enum FontName: String {
        case Regular = "Outfit-Regular"
        case Italic = "Outfit-Italic"
        case Thin = "Outfit-Thin"
        case ThinItalic = "Outfit-ThinItalic"
        case ExtraLight = "Outfit-ExtraLight"
        case ExtraLightItalic = "Outfit-ExtraLightItalic"
        case Light = "Outfit-Light"
        case LightItalic = "Outfit-LightItalic"
        case Medium = "Outfit-Medium"
        case MediumItalic = "Outfit-MediumItalic"
        case SemiBold = "Outfit-SemiBold"
        case SemiBoldItalic = "Outfit-SemiBoldItalic"
        case Bold = "Outfit-Bold"
        case BoldItalic = "Outfit-BoldItalic"
        case ExtraBold = "Outfit-ExtraBold"
        case ExtraBoldItalic = "Outfit-ExtraBoldItalic"
        case Black = "Outfit-Black"
        case BlackItalic = "Outfit-BlackItalic"
    }
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let StandardSize):
                return StandardSize.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum StandardSize: Double {
        case S10 = 10.0
        case S11 = 11.0
        case S12 = 12.0
        case S13 = 13.0
        case S14 = 14.0
        case S15 = 15.0
        case S16 = 16.0
        case S17 = 17.0
        case S18 = 18.0
        case S19 = 19.0
        case S20 = 20.0
        case S21 = 21.0
        case S22 = 22.0
        case S23 = 23.0
    }
    
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}

class Utility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}

func fontInProject() {
    for family in UIFont.familyNames {
        print("\(family)")
        for name in UIFont.fontNames(forFamilyName: family) {
            print("   \(name)")
        }
    }
}

