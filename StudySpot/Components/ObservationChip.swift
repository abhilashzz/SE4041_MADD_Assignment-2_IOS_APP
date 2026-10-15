import SwiftUI

/// Chip component displaying personal Wi-Fi, Power, or Noise observations.
public struct ObservationChip: View {
    public let icon: String
    public let label: String
    public var isHighlighted: Bool = false
    public var onTap: (() -> Void)? = nil
    
    public init(
        icon: String,
        label: String,
        isHighlighted: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.label = label
        self.isHighlighted = isHighlighted
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            if let onTap = onTap {
                Button(action: onTap) {
                    content
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                content
            }
        }
    }
    
    private var content: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isHighlighted ? Color.themePrimary : Color.themeMutedText)
            
            Text(label)
                .font(.system(.footnote, design: .rounded, weight: .medium))
                .foregroundColor(isHighlighted ? Color.themeMainText : Color.themeMutedText)
        }
        .padding(.horizontal, StudySpotTheme.spacing12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusSmall)
                .fill(isHighlighted ? Color.themeMint : Color.themeBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusSmall)
                .stroke(isHighlighted ? Color.themePrimary.opacity(0.3) : Color.themeSeparator, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
    }
}
