import SwiftUI

public struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        NavigationStack {
            List {
                // Brand Header
                Section {
                    VStack(spacing: StudySpotTheme.spacing12) {
                        LogoMarkIllustration()
                            .scaleEffect(1.5)
                            .padding(.top, StudySpotTheme.spacing8)
                        
                        Text("StudySpot")
                            .font(.system(.title, design: .serif, weight: .bold))
                            .foregroundColor(Color.themeMainText)
                        
                        Text("Find a place. Find your focus.")
                            .font(.subheadline)
                            .foregroundColor(Color.themeMutedText)
                        
                        Text("Version 1.0 · Advanced iOS Assignment")
                            .font(.caption)
                            .foregroundColor(Color.themeMutedText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, StudySpotTheme.spacing12)
                }
                
                // Student & Academic Credentials
                Section(header: Text("Authorship & Academic Details")) {
                    HStack {
                        Text("Student Name")
                        Spacer()
                        Text("Abhilash K A T W")
                            .foregroundColor(Color.themePrimary)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Student ID")
                        Spacer()
                        Text("IT22081698")
                            .foregroundColor(Color.themePrimary)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Module")
                        Spacer()
                        Text("SE4041 - MADD")
                            .foregroundColor(Color.themeMutedText)
                    }
                    
                    HStack {
                        Text("Assignment")
                        Spacer()
                        Text("Part A: Advanced iOS App")
                            .foregroundColor(Color.themeMutedText)
                    }
                }
                
                // Technology & Architecture
                Section(header: Text("Technology & Apple Frameworks")) {
                    Label("SwiftUI & NavigationStack", systemImage: "macwindow")
                    Label("MapKit Search & Interactive Maps", systemImage: "map")
                    Label("Core Location (When In Use only)", systemImage: "location")
                    Label("Core Data (Durable SQLite persistence)", systemImage: "cylinder.split.1x2")
                    Label("MVVM Architecture & Repository Pattern", systemImage: "square.grid.2x2")
                }
                
                // Demo Mode Configuration
                Section(
                    header: Text("Demonstration Mode"),
                    footer: Text("Demo Mode uses a dedicated separate database and mock fixtures (Leaf & Latte, Quiet Corner Library) so testing never alters your real study history.")
                ) {
                    Toggle("Enable Demo Mode", isOn: $appState.isDemoMode)
                        .tint(Color.themePrimary)
                }
            }
            .navigationTitle("About StudySpot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
