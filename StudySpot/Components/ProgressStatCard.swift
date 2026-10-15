import SwiftUI

/// Hero card displaying total study time with deep teal background and book mark
public struct HeroProgressCard: View {
    public let timeFormatted: String
    public let period: ProgressPeriod
    
    public init(timeFormatted: String, period: ProgressPeriod) {
        self.timeFormatted = timeFormatted
        self.period = period
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // Deep teal background
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.themePrimary,
                            Color(hex: "0F4840")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Decorative background leaf pattern
            HStack {
                Spacer()
                Image(systemName: "leaf.fill")
                    .font(.system(size: 90))
                    .foregroundColor(Color.white.opacity(0.08))
                    .rotationEffect(.degrees(25))
                    .offset(x: 15, y: 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard))
            
            // Card Content
            HStack(spacing: StudySpotTheme.spacing20) {
                // Book icon in warm badge
                ZStack {
                    RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.themeWarmAccent)
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(timeFormatted)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Study time")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.85))
                }
                
                Spacer()
            }
            .padding(StudySpotTheme.spacing20)
        }
        .frame(height: 110)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Total study time for \(period.displayName): \(timeFormatted)")
    }
}

/// Compact stat card for Sessions count or Average Focus rating
public struct ProgressStatCard: View {
    public let icon: String
    public let value: String
    public let label: String
    public var iconColor: Color = Color.themePrimary
    
    public init(icon: String, value: String, label: String, iconColor: Color = Color.themePrimary) {
        self.icon = icon
        self.value = value
        self.label = label
        self.iconColor = iconColor
    }
    
    public var body: some View {
        HStack(spacing: StudySpotTheme.spacing12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(Color.themeMainText)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(Color.themeMutedText)
            }
            
            Spacer()
        }
        .padding(StudySpotTheme.spacing16)
        .background(Color.themeSurface)
        .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
        .overlay(
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                .stroke(Color.themeSeparator.opacity(0.6), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}
