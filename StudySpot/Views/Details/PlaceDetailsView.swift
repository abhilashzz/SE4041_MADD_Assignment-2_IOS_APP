import SwiftUI

public struct PlaceDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PlaceDetailsViewModel
    
    public init(place: PlaceDTO, appState: AppState) {
        _viewModel = ObservedObject(wrappedValue: PlaceDetailsViewModel(place: place, appState: appState))
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: StudySpotTheme.spacing20) {
                // Top Hero Category Illustration Banner
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                        .fill(
                            LinearGradient(
                                colors: [Color.themeMint.opacity(0.8), Color.themeWarmAccent.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.place.categoryEnum.singularName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(Color.themePrimary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.themeSurface.opacity(0.85))
                                .clipShape(Capsule())
                        }
                        .padding(StudySpotTheme.spacing16)
                        
                        Spacer()
                        
                        StudyIllustrationView(type: viewModel.place.categoryEnum == .cafe ? .cafe : .library)
                            .scaleEffect(1.4)
                            .padding(.trailing, StudySpotTheme.spacing24)
                    }
                }
                
                // Place Name and Address
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.place.name)
                        .font(.system(.title, design: .serif, weight: .bold))
                        .foregroundColor(Color.themeMainText)
                    
                    Text(viewModel.place.subtitleDisplay)
                        .font(.subheadline)
                        .foregroundColor(Color.themeMutedText)
                }
                
                // Action Buttons Row: Saved & Directions
                HStack(spacing: StudySpotTheme.spacing12) {
                    // Save / Saved Toggle Button
                    Button(action: {
                        viewModel.toggleSave()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                            Text(viewModel.isSaved ? "Saved" : "Save place")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle(isFullWidth: true))
                    
                    // Directions Button (Apple Maps Handoff)
                    Button(action: {
                        viewModel.openAppleMapsDirections()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.north.fill")
                            Text("Directions")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(isDestructive: false, isFullWidth: true))
                }
                
                // Your Study Notes Section
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing12) {
                    HStack {
                        Text("Your study notes")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(Color.themeMainText)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.showEditNotesSheet = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.themePrimary)
                                .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                        }
                        .accessibilityLabel("Edit your study notes")
                    }
                    
                    // Personal Observation Chips
                    HStack(spacing: 8) {
                        ObservationChip(
                            icon: viewModel.place.wifiObservation.systemImage,
                            label: viewModel.place.wifiObservation.shortLabel,
                            isHighlighted: viewModel.place.wifiObservation != .unknown
                        )
                        
                        ObservationChip(
                            icon: viewModel.place.powerObservation.systemImage,
                            label: viewModel.place.powerObservation.shortLabel,
                            isHighlighted: viewModel.place.powerObservation != .unknown
                        )
                        
                        ObservationChip(
                            icon: viewModel.place.noiseObservation.systemImage,
                            label: viewModel.place.noiseObservation.shortLabel,
                            isHighlighted: viewModel.place.noiseObservation != .unknown
                        )
                    }
                    
                    // Personal Note Text Card
                    if let note = viewModel.place.personalNote, !note.isEmpty {
                        Text(note)
                            .font(.body)
                            .foregroundColor(Color.themeMainText)
                            .padding(StudySpotTheme.spacing16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.themeSurface)
                            .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                            .overlay(
                                RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                                    .stroke(Color.themeSeparator.opacity(0.8), lineWidth: 1)
                            )
                    } else {
                        Text("No personal notes yet. Tap the pencil to record Wi-Fi, power, or noise observations.")
                            .font(.footnote)
                            .foregroundColor(Color.themeMutedText)
                            .italic()
                            .padding(StudySpotTheme.spacing12)
                    }
                }
                
                // Recent Session Section
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing8) {
                    Text("Recent session")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(Color.themeMainText)
                    
                    if let latest = viewModel.sessions.first {
                        HStack(spacing: 12) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(Color.themePrimary)
                            Text(latest.focusSummary)
                                .font(.subheadline)
                                .foregroundColor(Color.themeMainText)
                            
                            Spacer()
                            
                            Text(latest.completedAt, style: .date)
                                .font(.caption)
                                .foregroundColor(Color.themeMutedText)
                        }
                        .padding(StudySpotTheme.spacing12)
                        .background(Color.themeSurface)
                        .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusSmall))
                        .overlay(
                            RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusSmall)
                                .stroke(Color.themeSeparator.opacity(0.7), lineWidth: 1)
                        )
                    } else {
                        Text("No sessions logged for this spot yet.")
                            .font(.footnote)
                            .foregroundColor(Color.themeMutedText)
                    }
                }
                
                // Log Study Session Button
                Button(action: {
                    viewModel.showLogSessionSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Log study session")
                    }
                }
                .buttonStyle(PrimaryButtonStyle(isDestructive: false, isFullWidth: true))
                .padding(.top, StudySpotTheme.spacing8)
            }
            .padding(StudySpotTheme.spacing20)
        }
        .background(Color.themeBackground.ignoresSafeArea())
        .navigationTitle(viewModel.place.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Bookmark Toggle in Navigation Bar
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleSave()
                }) {
                    Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundColor(viewModel.isSaved ? Color.themePrimary : Color.themeMutedText)
                }
                .accessibilityIdentifier("detailsBookmarkButton")
                .accessibilityLabel(viewModel.isSaved ? "Remove from saved places" : "Save place")
            }
            
            // Delete Local Place Menu
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        viewModel.showDeleteConfirmation = true
                    }) {
                        Label("Delete Local Place Record", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color.themeMutedText)
                }
            }
        }
        .sheet(isPresented: $viewModel.showEditNotesSheet) {
            EditNotesSheet(place: viewModel.place) { wifi, power, noise, note in
                viewModel.updateObservations(wifi: wifi, power: power, noise: noise, personalNote: note)
            }
        }
        .sheet(isPresented: $viewModel.showLogSessionSheet) {
            LogSessionSheet(
                draft: StudySessionDraft(placeId: viewModel.place.id, placeName: viewModel.place.name)
            ) { draft in
                viewModel.logSession(draft: draft)
            }
        }
        .confirmationDialog(
            "Delete Local Record?",
            isPresented: $viewModel.showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Place and \(viewModel.linkedSessionCount) Linked Sessions", role: .destructive) {
                try? viewModel.deletePlacePermanently()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove \(viewModel.place.name) and its \(viewModel.linkedSessionCount) associated study sessions from your local database. It does not delete the venue from Apple Maps.")
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
