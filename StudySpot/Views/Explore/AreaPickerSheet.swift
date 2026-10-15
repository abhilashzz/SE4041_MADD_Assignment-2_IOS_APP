import SwiftUI
import MapKit

public struct AreaPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appState: AppState
    let onAreaSelected: () -> Void
    
    public init(appState: AppState, onAreaSelected: @escaping () -> Void) {
        self.appState = appState
        self.onAreaSelected = onAreaSelected
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Preset Study Regions")) {
                    ForEach(SearchArea.presetAreas) { area in
                        Button(action: {
                            appState.selectedArea = area
                            onAreaSelected()
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(area.name)
                                        .font(.headline)
                                        .foregroundColor(Color.themeMainText)
                                    Text("Lat: \(String(format: "%.4f", area.coordinate.latitude)), Lon: \(String(format: "%.4f", area.coordinate.longitude))")
                                        .font(.caption)
                                        .foregroundColor(Color.themeMutedText)
                                }
                                
                                Spacer()
                                
                                if appState.selectedArea.name == area.name {
                                    Image(systemName: "checkmark")
                                        .font(.headline)
                                        .foregroundColor(Color.themePrimary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Search Area")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
