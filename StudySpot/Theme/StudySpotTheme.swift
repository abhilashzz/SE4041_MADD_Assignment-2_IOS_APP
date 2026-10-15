import SwiftUI

/// StudySpot design system tokens and semantic color definitions
public struct StudySpotTheme {
    // MARK: - Spacing & Radius Tokens
    public static let spacing4: CGFloat = 4
    public static let spacing8: CGFloat = 8
    public static let spacing12: CGFloat = 12
    public static let spacing16: CGFloat = 16
    public static let spacing20: CGFloat = 20
    public static let spacing24: CGFloat = 24
    public static let spacing32: CGFloat = 32
    
    public static let cornerRadiusSmall: CGFloat = 10
    public static let cornerRadiusMedium: CGFloat = 16
    public static let cornerRadiusCard: CGFloat = 22
    public static let cornerRadiusLarge: CGFloat = 28
    
    public static let minTouchTarget: CGFloat = 44
}

// MARK: - Semantic Color Definitions
extension Color {
    public static let studyBackground = Color("StudyBackground", bundle: nil)
    public static let studySurface = Color("StudySurface", bundle: nil)
    public static let studyPrimary = Color("StudyPrimary", bundle: nil)
    public static let studyMainText = Color("StudyMainText", bundle: nil)
    public static let studyMint = Color("StudyMint", bundle: nil)
    public static let studyMutedText = Color("StudyMutedText", bundle: nil)
    public static let studySeparator = Color("StudySeparator", bundle: nil)
    public static let studyWarmAccent = Color("StudyWarmAccent", bundle: nil)
    public static let studyDestructive = Color("StudyDestructive", bundle: nil)
    
    // Fallback dynamic colors when running without asset catalog or in previews
    public static func dynamic(lightHex: String, darkHex: String) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(hex: darkHex)
            } else {
                return UIColor(hex: lightHex)
            }
        })
        #else
        return Color(hex: lightHex)
        #endif
    }
    
    // Dynamic theme colors matching the cream/teal aesthetic
    public static let themeBackground = Color.dynamic(lightHex: "F6F7F2", darkHex: "111817")
    public static let themeSurface = Color.dynamic(lightHex: "FFFFFF", darkHex: "1B2423")
    public static let themePrimary = Color.dynamic(lightHex: "176459", darkHex: "359183")
    public static let themeMainText = Color.dynamic(lightHex: "183B36", darkHex: "E8F0EE")
    public static let themeMint = Color.dynamic(lightHex: "E6F0E9", darkHex: "1D332F")
    public static let themeMutedText = Color.dynamic(lightHex: "70817C", darkHex: "9EB0AB")
    public static let themeSeparator = Color.dynamic(lightHex: "DEE5E0", darkHex: "2A3A36")
    public static let themeWarmAccent = Color.dynamic(lightHex: "EBC77A", darkHex: "F0D28E")
    public static let themeDestructive = Color.dynamic(lightHex: "D9534F", darkHex: "E57373")
    
    // Hex Initializer
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#if canImport(UIKit)
import UIKit
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
#endif
