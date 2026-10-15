import SwiftUI

/// Deep teal rounded button style with press animation and minimum 44pt touch target.
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public var isDestructive: Bool = false
    public var isFullWidth: Bool = true
    
    public init(isDestructive: Bool = false, isFullWidth: Bool = true) {
        self.isDestructive = isDestructive
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, StudySpotTheme.spacing20)
            .padding(.vertical, StudySpotTheme.spacing12)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(minHeight: StudySpotTheme.minTouchTarget)
            .background(
                RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                    .fill(isDestructive ? Color.themeDestructive : Color.themePrimary)
            )
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Outline/secondary button style
public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public var isFullWidth: Bool = false
    
    public init(isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded, weight: .semibold))
            .foregroundColor(Color.themePrimary)
            .padding(.horizontal, StudySpotTheme.spacing16)
            .padding(.vertical, StudySpotTheme.spacing12)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(minHeight: StudySpotTheme.minTouchTarget)
            .background(
                RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                    .fill(Color.themeMint.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                    .stroke(Color.themePrimary.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
