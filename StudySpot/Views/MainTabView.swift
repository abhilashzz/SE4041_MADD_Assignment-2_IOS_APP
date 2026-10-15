import SwiftUI

/// Main persistent tab bar for StudySpot containing Explore, Map, Saved, and Progress tabs.
public struct MainTabView: View {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            ExploreView(appState: appState)
                .tabItem {
                    Label(AppTab.explore.title, systemImage: AppTab.explore.systemImage)
                }
                .tag(AppTab.explore)
            
            StudyMapView(appState: appState)
                .tabItem {
                    Label(AppTab.map.title, systemImage: AppTab.map.systemImage)
                }
                .tag(AppTab.map)
            
            SavedPlacesView(appState: appState)
                .tabItem {
                    Label(AppTab.saved.title, systemImage: AppTab.saved.systemImage)
                }
                .tag(AppTab.saved)
            
            ProgressView(appState: appState)
                .tabItem {
                    Label(AppTab.progress.title, systemImage: AppTab.progress.systemImage)
                }
                .tag(AppTab.progress)
        }
        .tint(Color.themePrimary)
    }
}
