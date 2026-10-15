import SwiftUI

public struct ProgressView: View {
    @ObservedObject var appState: AppState
    @StateObject private var viewModel: ProgressViewModel
    
    public init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: ProgressViewModel(appState: appState))
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: StudySpotTheme.spacing20) {
                    // Header Row: Heading + Settings Gear
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your study progress")
                                .font(.system(.title2, design: .serif, weight: .bold))
                                .foregroundColor(Color.themeMainText)
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
                        
                        Button(action: {
                            appState.showAboutSheet = true
                        }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.themeMainText)
                                .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                        }
                        .accessibilityLabel("Settings and About")
                    }
                    .padding(.top, StudySpotTheme.spacing8)
                    
                    // Period Selector Dropdown
                    Menu {
                        ForEach(ProgressPeriod.allCases) { period in
                            Button(action: {
                                viewModel.selectedPeriod = period
                            }) {
                                HStack {
                                    Text(period.displayName)
                                    if viewModel.selectedPeriod == period {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(viewModel.selectedPeriod.displayName)
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
                    
                    // 1. Hero Stat Card
                    HeroProgressCard(
                        timeFormatted: viewModel.aggregate.heroTimeFormatted,
                        period: viewModel.selectedPeriod
                    )
                    
                    // 2. Secondary Metrics Grid (Sessions & Average Focus)
                    HStack(spacing: StudySpotTheme.spacing12) {
                        ProgressStatCard(
                            icon: "calendar",
                            value: "\(viewModel.aggregate.sessionCount)",
                            label: "Sessions",
                            iconColor: Color.themePrimary
                        )
                        
                        ProgressStatCard(
                            icon: "chart.bar.fill",
                            value: viewModel.aggregate.averageFocusFormatted,
                            label: "Average focus",
                            iconColor: Color.themePrimary
                        )
                    }
                    
                    // 3. Weekly Bar Chart
                    VStack(alignment: .leading, spacing: StudySpotTheme.spacing12) {
                        Text("Study time this week")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(Color.themeMainText)
                        
                        StudyWeekBarChart(dailyPoints: viewModel.aggregate.dailyPoints)
                    }
                    .padding(StudySpotTheme.spacing16)
                    .background(Color.themeSurface)
                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard))
                    .overlay(
                        RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusCard)
                            .stroke(Color.themeSeparator.opacity(0.6), lineWidth: 1)
                    )
                    
                    // 4. Recent Sessions List
                    VStack(alignment: .leading, spacing: StudySpotTheme.spacing12) {
                        Text("Recent sessions")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(Color.themeMainText)
                        
                        if viewModel.recentSessions.isEmpty {
                            Text("No study sessions recorded yet. Tap '+ Log study session' on any place details screen.")
                                .font(.footnote)
                                .foregroundColor(Color.themeMutedText)
                                .padding(.vertical, StudySpotTheme.spacing12)
                        } else {
                            LazyVStack(spacing: StudySpotTheme.spacing12) {
                                ForEach(viewModel.recentSessions) { session in
                                    HStack(spacing: StudySpotTheme.spacing16) {
                                        // Category Thumbnail
                                        StudyIllustrationView(type: session.placeCategory == "Cafés" ? .cafe : .library)
                                            .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusSmall))
                                            .frame(width: 44, height: 44)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(session.placeName)
                                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                                .foregroundColor(Color.themeMainText)
                                            
                                            Text(session.focusSummary)
                                                .font(.caption)
                                                .foregroundColor(Color.themeMutedText)
                                        }
                                        
                                        Spacer()
                                        
                                        // Edit Session Button
                                        Button(action: {
                                            viewModel.startEditing(session: session)
                                        }) {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(Color.themeMutedText)
                                                .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                                        }
                                        .accessibilityLabel("Edit session at \(session.placeName)")
                                        
                                        // Delete Session Menu
                                        Menu {
                                            Button(role: .destructive, action: {
                                                viewModel.deleteSession(session)
                                            }) {
                                                Label("Delete Session", systemImage: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.themeMutedText)
                                                .frame(width: StudySpotTheme.minTouchTarget, height: StudySpotTheme.minTouchTarget)
                                        }
                                    }
                                    .padding(StudySpotTheme.spacing12)
                                    .background(Color.themeSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: StudySpotTheme.cornerRadiusMedium)
                                            .stroke(Color.themeSeparator.opacity(0.6), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, StudySpotTheme.spacing20)
                .padding(.bottom, StudySpotTheme.spacing32)
            }
            .background(Color.themeBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(item: $viewModel.sessionToEdit) { draft in
                LogSessionSheet(draft: draft, isEditing: true) { updatedDraft in
                    viewModel.saveEditedSession(draft: updatedDraft)
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

// MARK: - Accessible Weekly Study Time Bar Chart
struct StudyWeekBarChart: View {
    let dailyPoints: [DailyStudyPoint]
    
    private var maxMinutes: Int {
        let maxVal = dailyPoints.map { $0.minutes }.max() ?? 60
        return max(maxVal, 60)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(dailyPoints) { point in
                VStack(spacing: 6) {
                    // Bar
                    GeometryReader { geo in
                        VStack {
                            Spacer()
                            
                            let ratio = CGFloat(point.minutes) / CGFloat(maxMinutes)
                            let height = max(ratio * geo.size.height, point.minutes > 0 ? 12 : 4)
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(point.minutes > 0 ? Color.themePrimary.opacity(0.85) : Color.themeSeparator.opacity(0.5))
                                .frame(height: height)
                        }
                    }
                    .frame(height: 100)
                    
                    // Day Label
                    Text(point.dayLabel)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.themeMutedText)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(point.dayLabel): \(point.minutes) minutes of study time")
            }
        }
        .frame(height: 130)
    }
}
