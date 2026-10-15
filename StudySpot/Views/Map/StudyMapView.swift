import SwiftUI
import MapKit

public struct StudyMapView: View {
    @ObservedObject var appState: AppState
    @StateObject private var viewModel: MapViewModel
    
    public init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: MapViewModel(appState: appState))
    }
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Real Map
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.markers) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        MapMarkerPin(
                            place: place,
                            isSelected: viewModel.selectedPlace?.id == place.id
                        ) {
                            withAnimation(.spring()) {
                                viewModel.selectMarker(place)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Top Overlays: Header, Search Bar & "Search this area"
                VStack(spacing: StudySpotTheme.spacing12) {
                    // Header Row
                    HStack {
                        Text("Explore the map")
                            .font(.system(.title2, design: .serif, weight: .bold))
                            .foregroundColor(Color.themeMainText)
                        
                        Spacer()
                        
                        if appState.isDemoMode {
                            Text("Demo area")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.themePrimary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.themeMint)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, StudySpotTheme.spacing20)
                    .padding(.top, StudySpotTheme.spacing8)
                    
                    // Search Bar
                    HStack(spacing: StudySpotTheme.spacing12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.themeMutedText)
                        
                        TextField("Search cafés or libraries", text: $viewModel.searchText)
                            .font(.system(.body, design: .rounded))
                            .onSubmit {
                                viewModel.searchVisibleArea()
                            }
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                viewModel.searchVisibleArea()
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
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                    .padding(.horizontal, StudySpotTheme.spacing20)
                    
                    // Floating "Search this area" Pill Button
                    Button(action: {
                        viewModel.searchVisibleArea()
                    }) {
                        HStack(spacing: 6) {
                            if viewModel.isSearching {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            Text("Search this area")
                                .font(.system(.footnote, design: .rounded, weight: .bold))
                        }
                        .foregroundColor(Color.themePrimary)
                        .padding(.horizontal, StudySpotTheme.spacing16)
                        .padding(.vertical, 8)
                        .background(Color.themeSurface)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.themeSeparator, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
                    }
                    .accessibilityLabel("Search for study spots in the visible map region")
                }
                
                // Bottom Floating Controls: Near Me & Selected Place Card
                VStack {
                    Spacer()
                    
                    // Near Me Floating Button
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.nearMe()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color.themePrimary)
                                .frame(width: 48, height: 48)
                                .background(Color.themeSurface)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.themeSeparator, lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                        }
                        .padding(.trailing, StudySpotTheme.spacing20)
                        .accessibilityLabel("Find study spots near me")
                    }
                    
                    // Floating Selected Place Bottom Card
                    if let selected = viewModel.selectedPlace {
                        NavigationLink(destination: PlaceDetailsView(place: selected, appState: appState)) {
                            HStack(spacing: StudySpotTheme.spacing16) {
                                StudyIllustrationView(type: selected.categoryEnum == .cafe ? .cafe : .library)
                                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(selected.name)
                                        .font(.system(.headline, design: .rounded, weight: .bold))
                                        .foregroundColor(Color.themeMainText)
                                        .lineLimit(1)
                                    
                                    Text(selected.subtitleDisplay)
                                        .font(.caption)
                                        .foregroundColor(Color.themeMutedText)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Text("View place")
                                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, StudySpotTheme.spacing16)
                                    .padding(.vertical, 10)
                                    .background(Color.themePrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                            }
                            .padding(StudySpotTheme.spacing16)
                            .background(Color.themeSurface)
                            .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard))
                            .overlay(
                                RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                                    .stroke(Color.themeSeparator, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, StudySpotTheme.spacing20)
                        .padding(.bottom, StudySpotTheme.spacing20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .background(Color.themeBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

// MARK: - Custom Map Marker Pin
struct MapMarkerPin: View {
    let place: PlaceDTO
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.themeWarmAccent : Color.themePrimary)
                        .frame(width: isSelected ? 42 : 36, height: isSelected ? 42 : 36)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: place.categoryEnum == .cafe ? "cup.and.saucer.fill" : "book.closed.fill")
                        .font(.system(size: isSelected ? 18 : 15, weight: .bold))
                        .foregroundColor(isSelected ? Color.themeMainText : .white)
                }
                
                // Pin pointer triangle
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? Color.themeWarmAccent : Color.themePrimary)
                    .offset(y: -2)
            }
        }
        .scaleEffect(isSelected ? 1.15 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .accessibilityLabel("\(place.name), \(place.categoryEnum.singularName)")
    }
}
