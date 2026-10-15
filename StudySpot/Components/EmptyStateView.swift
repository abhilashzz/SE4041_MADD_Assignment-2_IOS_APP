import SwiftUI

/// Reusable empty or error state placeholder with optional action button.
public struct EmptyStateView: View {
    public let icon: String
    public let title: String
    public let message: String
    public var actionTitle: String? = nil
    public var action: (() -> Void)? = nil
    
    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: StudySpotTheme.spacing16) {
            ZStack {
                Circle()
                    .fill(Color.themeMint.opacity(0.8))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(Color.themePrimary)
            }
            .accessibilityHidden(true)
            
            VStack(spacing: StudySpotTheme.spacing8) {
                Text(title)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(Color.themeMainText)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Color.themeMutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StudySpotTheme.spacing24)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: false))
                .padding(.top, StudySpotTheme.spacing8)
            }
        }
        .padding(StudySpotTheme.spacing32)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}
