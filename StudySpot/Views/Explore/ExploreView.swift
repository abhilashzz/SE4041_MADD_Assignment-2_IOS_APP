import SwiftUI

public struct ExploreView: View {
    @ObservedObject var appState: AppState
    @StateObject private var viewModel: ExploreViewModel
    
    public init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: ExploreViewModel(appState: appState))
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing20) {
                    // 1. Brand Row
                    HStack {
                        HStack(spacing: StudySpotTheme.spacing8) {
                            LogoMarkIllustration()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("StudySpot")
                                    .font(.system(.title3, design: .serif, weight: .bold))
                                    .foregroundColor(Color.themeMainText)
                                
                                Text("Find a place. Find your focus.")
                                    .font(.caption2)
                                    .foregroundColor(Color.themeMutedText)
                            }
                        }
                        
                        Spacer()
                        
                        // About / Info Button
                        Button(action: {
                            appState.showAboutSheet = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.themeMainText)
                                .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                        }
                        .accessibilityLabel("About StudySpot")
                    }
                    .padding(.top, StudySpotTheme.spacing8)
                    
                    // 2. Heading
                    Text("Find your next\nstudy spot")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundColor(Color.themeMainText)
                        .lineSpacing(4)
                    
                    // 3. Search Area Selector Chip & Demo Badge
                    HStack {
                        Button(action: {
                            appState.showAreaPickerSheet = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color.themePrimary)
                                
                                Text(appState.selectedArea.name)
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundColor(Color.themeMainText)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color.themeMutedText)
                            }
                            .padding(.horizontal, StudySpotTheme.spacing12)
                            .padding(.vertical, 8)
                            .background(Color.themeSurface)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Color.themeSeparator, lineWidth: 1)
                            )
                        }
                        .accessibilityLabel("Selected search area: \(appState.selectedArea.name). Tap to change area.")
                        
                        Spacer()
                        
                        if appState.isDemoMode {
                            Text("Demo places")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.themePrimary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.themeMint)
                                .clipShape(Capsule())
                        }
                    }
                    
                    // 4. Search Field
                    HStack(spacing: StudySpotTheme.spacing12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.themeMutedText)
                            .font(.system(size: 17))
                        
                        TextField("Search cafés or libraries", text: $viewModel.searchText)
                            .font(.system(.body, design: .rounded))
                            .autocorrectionDisabled()
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.themeMutedText)
                            }
                        }
                    }
                    .padding(StudySpotTheme.spacing12)
                    .background(Color.themeSurface)
                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                    .overlay(
                        RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                            .stroke(Color.themeSeparator, lineWidth: 1)
                    )
                    
                    // 5. Category Chips: All, Libraries, Cafés
                    HStack(spacing: StudySpotTheme.spacing8) {
                        ForEach(StudyPlaceCategory.allCases) { category in
                            let isSelected = viewModel.selectedCategory == category
                            Button(action: {
                                viewModel.selectCategory(category)
                            }) {
                                HStack(spacing: 6) {
                                    if category != .all {
                                        Image(systemName: category.systemImage)
                                            .font(.system(size: 12))
                                    }
                                    Text(category.displayName)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                }
                                .padding(.horizontal, StudySpotTheme.spacing16)
                                .padding(.vertical, 8)
                                .background(isSelected ? Color.themePrimary : Color.themeSurface)
                                .foregroundColor(isSelected ? .white : Color.themeMainText)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(isSelected ? Color.clear : Color.themeSeparator, lineWidth: 1)
                                )
                            }
                            .accessibilityLabel("\(category.displayName) filter")
                            .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                        }
                    }
                    
                    // 6. Warm Book Illustration Banner
                    StudyIllustrationView(type: .banner)
                    
                    // 7. Section Header
                    Text("Places to explore")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(Color.themeMainText)
                    
                    // 8. Results List or Status States
                    switch viewModel.loadingState {
                    case .loading:
                        HStack {
                            Spacer()
                            SwiftUI.ProgressView("Searching study spots...")
                                .padding(StudySpotTheme.spacing24)
                            Spacer()
                        }
                    case .empty:
                        EmptyStateView(
                            icon: "cup.and.saucer",
                            title: "No Study Spots Found",
                            message: "We couldn't find cafés or libraries matching '\(viewModel.searchText)' in \(appState.selectedArea.name). Try another keyword or switch area.",
                            actionTitle: "Clear Search"
                        ) {
                            viewModel.searchText = ""
                            viewModel.performSearch()
                        }
                    case .error(let message):
                        EmptyStateView(
                            icon: "wifi.exclamationmark",
                            title: "Search Unavailable",
                            message: message,
                            actionTitle: "Retry Search"
                        ) {
                            viewModel.performSearch()
                        }
                    case .idle, .success:
                        LazyVStack(spacing: StudySpotTheme.spacing12) {
                            ForEach(viewModel.results) { place in
                                NavigationLink(destination: PlaceDetailsView(place: place, appState: appState)) {
                                    StudyPlaceCard(
                                        place: place,
                                        onBookmarkTapped: {
                                            viewModel.toggleBookmark(for: place)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal, StudySpotTheme.spacing20)
                .padding(.bottom, StudySpotTheme.spacing32)
            }
            .background(Color.themeBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $appState.showAboutSheet) {
                AboutView(appState: appState)
            }
            .sheet(isPresented: $appState.showAreaPickerSheet) {
                AreaPickerSheet(appState: appState) {
                    viewModel.performSearch()
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}
