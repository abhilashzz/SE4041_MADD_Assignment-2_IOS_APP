import SwiftUI

/// Reusable card component for displaying study places across Explore, Map, and Saved tabs.
public struct StudyPlaceCard: View {
    public let place: PlaceDTO
    public let showNotePreview: Bool
    public let onBookmarkTapped: () -> Void
    public var onEditNoteTapped: (() -> Void)? = nil
    
    public init(
        place: PlaceDTO,
        showNotePreview: Bool = false,
        onBookmarkTapped: @escaping () -> Void,
        onEditNoteTapped: (() -> Void)? = nil
    ) {
        self.place = place
        self.showNotePreview = showNotePreview
        self.onBookmarkTapped = onBookmarkTapped
        self.onEditNoteTapped = onEditNoteTapped
    }
    
    public var body: some View {
        HStack(spacing: StudySpotTheme.spacing16) {
            // Category Illustration Thumbnail
            StudyIllustrationView(type: place.categoryEnum == .cafe ? .cafe : .library)
                .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
            
            // Name and Details
            VStack(alignment: .leading, spacing: StudySpotTheme.spacing4) {
                Text(place.name)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundColor(Color.themeMainText)
                    .lineLimit(1)
                
                if showNotePreview, let note = place.personalNote, !note.isEmpty {
                    Text("Your note: \(note)")
                        .font(.subheadline)
                        .foregroundColor(Color.themeMutedText)
                        .lineLimit(1)
                } else {
                    Text(place.subtitleDisplay)
                        .font(.subheadline)
                        .foregroundColor(Color.themeMutedText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Edit Note Action (optional, used in Saved Places)
            if let onEditNote = onEditNoteTapped {
                Button(action: onEditNote) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.themeMutedText)
                        .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                }
                .accessibilityLabel("Edit note for \(place.name)")
            }
            
            // Bookmark Toggle Button
            Button(action: {
                #if canImport(UIKit)
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                #endif
                onBookmarkTapped()
            }) {
                Image(systemName: place.isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(place.isSaved ? Color.themePrimary : Color.themeMutedText)
                    .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel(place.isSaved ? "Saved \(place.name). Tap to unsave." : "Save \(place.name)")
            .accessibilityHint("Double tap to toggle bookmark for this study spot.")
        }
        .padding(StudySpotTheme.spacing16)
        .background(Color.themeSurface)
        .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard))
        .overlay(
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                .stroke(Color.themeSeparator.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
}
