import SwiftUI

public struct SavedPlacesView: View {
    @ObservedObject var appState: AppState
    @StateObject private var viewModel: SavedPlacesViewModel
    
    public init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: SavedPlacesViewModel(appState: appState))
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing20) {
                    // Header Row
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your saved places")
                                .font(.system(.title2, design: .serif, weight: .bold))
                                .foregroundColor(Color.themeMainText)
                            
                            Text("Good spaces, kept close.")
                                .font(.subheadline)
                                .foregroundColor(Color.themeMutedText)
                        }
                        
                        Spacer()
                        
                        if appState.isDemoMode {
                            Text("Demo data")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.themePrimary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.themeMint)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, StudySpotTheme.spacing8)
                    
                    // Search Bar
                    HStack(spacing: StudySpotTheme.spacing12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.themeMutedText)
                        
                        TextField("Search saved places", text: $viewModel.searchText)
                            .font(.system(.body, design: .rounded))
                        
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
                    
                    // Saved Places List or Empty State
                    if viewModel.filteredPlaces.isEmpty {
                        EmptyStateView(
                            icon: "bookmark.slash",
                            title: viewModel.savedPlaces.isEmpty ? "No Saved Places Yet" : "No Matching Spots",
                            message: viewModel.savedPlaces.isEmpty
                                ? "Bookmark libraries or cafés from the Explore tab to save them here for quick access."
                                : "No saved spots matched '\(viewModel.searchText)'.",
                            actionTitle: viewModel.savedPlaces.isEmpty ? "Explore Places" : "Clear Filter"
                        ) {
                            if viewModel.savedPlaces.isEmpty {
                                appState.selectedTab = .explore
                            } else {
                                viewModel.searchText = ""
                            }
                        }
                    } else {
                        LazyVStack(spacing: StudySpotTheme.spacing12) {
                            ForEach(viewModel.filteredPlaces) { place in
                                NavigationLink(destination: PlaceDetailsView(place: place, appState: appState)) {
                                    StudyPlaceCard(
                                        place: place,
                                        showNotePreview: true,
                                        onBookmarkTapped: {
                                            viewModel.unsavePlace(place)
                                        },
                                        onEditNoteTapped: {
                                            viewModel.placeToEditNotes = place
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button(action: {
                                        viewModel.placeToEditNotes = place
                                    }) {
                                        Label("Edit Study Notes", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        viewModel.unsavePlace(place)
                                    }) {
                                        Label("Unsave Place", systemImage: "bookmark.slash")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        viewModel.placeToDelete = place
                                    }) {
                                        Label("Delete Place Permanently", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    
                    // Info Callout Card
                    HStack(alignment: .top, spacing: StudySpotTheme.spacing12) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.themePrimary)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your notes are personal.")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundColor(Color.themeMainText)
                            
                            Text("These notes help you remember what works for you. They are only visible to you.")
                                .font(.footnote)
                                .foregroundColor(Color.themeMutedText)
                                .lineSpacing(2)
                        }
                    }
                    .padding(StudySpotTheme.spacing16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.themeMint.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                    .overlay(
                        RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                            .stroke(Color.themePrimary.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.top, StudySpotTheme.spacing12)
                }
                .padding(.horizontal, StudySpotTheme.spacing20)
                .padding(.bottom, StudySpotTheme.spacing32)
            }
            .background(Color.themeBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(item: $viewModel.placeToEditNotes) { place in
                EditNotesSheet(place: place) { wifi, power, noise, note in
                    try? appState.placeRepository.updateObservations(
                        id: place.id,
                        wifi: wifi,
                        power: power,
                        noise: noise,
                        personalNote: note
                    )
                    viewModel.loadSavedPlaces()
                }
            }
            .confirmationDialog(
                "Delete Local Place Record?",
                isPresented: Binding(
                    get: { viewModel.placeToDelete != nil },
                    set: { if !$0 { viewModel.placeToDelete = nil } }
                ),
                titleVisibility: .visible,
                presenting: viewModel.placeToDelete
            ) { place in
                Button("Delete Place and Linked Sessions", role: .destructive) {
                    viewModel.deletePermanently(place)
                }
                Button("Cancel", role: .cancel) {}
            } message: { place in
                Text("This permanently deletes \(place.name) and any associated session history from your local device.")
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}
