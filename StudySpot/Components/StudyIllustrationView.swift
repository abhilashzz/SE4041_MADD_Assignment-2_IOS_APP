import SwiftUI

/// Vector artwork and illustrations replicating the calm cream/teal study aesthetic
public struct StudyIllustrationView: View {
    public enum IllustrationType {
        case banner
        case cafe
        case library
        case logo
    }
    
    public let type: IllustrationType
    
    public init(type: IllustrationType) {
        self.type = type
    }
    
    public var body: some View {
        switch type {
        case .banner:
            BannerIllustration()
        case .cafe:
            CafeIllustration()
        case .library:
            LibraryIllustration()
        case .logo:
            LogoMarkIllustration()
        }
    }
}

// MARK: - Banner Illustration ("A little space to focus.")
struct BannerIllustration: View {
    var body: some View {
        ZStack {
            // Soft warm background
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.themeMint.opacity(0.7),
                            Color.themeWarmAccent.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack(spacing: StudySpotTheme.spacing16) {
                // Text callout
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing8) {
                    Text("A little space\nto focus.")
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .foregroundColor(Color.themeMainText)
                        .lineSpacing(4)
                    
                    Text("Calm places around you")
                        .font(.footnote)
                        .foregroundColor(Color.themeMutedText)
                }
                .padding(.leading, StudySpotTheme.spacing20)
                
                Spacer()
                
                // Vector study scene: Book + Coffee + Plant leaf
                ZStack {
                    // Decorative foliage
                    Circle()
                        .fill(Color.themePrimary.opacity(0.12))
                        .frame(width: 90, height: 90)
                        .offset(x: 10, y: -5)
                    
                    // Tropical leaf shape
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 44))
                        .foregroundColor(Color.themePrimary.opacity(0.7))
                        .rotationEffect(.degrees(35))
                        .offset(x: 25, y: -20)
                    
                    // Open Book
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 54))
                        .foregroundColor(Color.themeWarmAccent)
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .offset(x: -10, y: 10)
                    
                    // Steaming coffee cup
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color.themePrimary)
                        .offset(x: 32, y: 15)
                }
                .padding(.trailing, StudySpotTheme.spacing16)
            }
            .padding(.vertical, StudySpotTheme.spacing16)
        }
        .frame(height: 120)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("A little space to focus. Illustration of an open book and coffee cup.")
    }
}

// MARK: - Cafe Illustration Thumbnail
struct CafeIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                .fill(
                    LinearGradient(
                        colors: [Color.themeWarmAccent.opacity(0.4), Color.themeMint.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 4) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.themePrimary)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.themePrimary.opacity(0.6))
            }
        }
        .frame(width: 58, height: 58)
        .accessibilityHidden(true)
    }
}

// MARK: - Library Illustration Thumbnail
struct LibraryIllustration: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                .fill(
                    LinearGradient(
                        colors: [Color.themeMint.opacity(0.8), Color.themeWarmAccent.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 4) {
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.themePrimary)
                
                Image(systemName: "lamp.table.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.themeWarmAccent)
            }
        }
        .frame(width: 58, height: 58)
        .accessibilityHidden(true)
    }
}

// MARK: - App Brand Logo Mark (Book + Location Pin)
public struct LogoMarkIllustration: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            // Open book
            Image(systemName: "book.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.themePrimary)
            
            // Map pin overlapping top center of the book
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.themeWarmAccent)
                .background(Circle().fill(Color.themeSurface).frame(width: 14, height: 14))
                .offset(y: -12)
        }
        .frame(width: 36, height: 36)
        .accessibilityHidden(true)
    }
}
