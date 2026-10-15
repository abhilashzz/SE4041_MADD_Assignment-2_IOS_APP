import SwiftUI

public struct EditNotesSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeName: String
    @State private var wifi: WiFiObservation
    @State private var power: PowerObservation
    @State private var noise: NoiseObservation
    @State private var personalNote: String
    
    let onSave: (WiFiObservation, PowerObservation, NoiseObservation, String?) -> Void
    
    public init(
        place: PlaceDTO,
        onSave: @escaping (WiFiObservation, PowerObservation, NoiseObservation, String?) -> Void
    ) {
        self.placeName = place.name
        _wifi = State(initialValue: place.wifiObservation)
        _power = State(initialValue: place.powerObservation)
        _noise = State(initialValue: place.noiseObservation)
        _personalNote = State(initialValue: place.personalNote ?? "")
        self.onSave = onSave
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(
                    header: Text("Personal Study Suitability"),
                    footer: Text("These observations are private notes saved on your device to help you decide where to study.")
                ) {
                    Picker("Wi-Fi Availability", selection: $wifi) {
                        ForEach(WiFiObservation.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    
                    Picker("Power Outlets", selection: $power) {
                        ForEach(PowerObservation.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    
                    Picker("Noise Level", selection: $noise) {
                        ForEach(NoiseObservation.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }
                
                Section(header: Text("Your Study Notes")) {
                    TextEditor(text: $personalNote)
                        .frame(minHeight: 100)
                    
                    HStack {
                        Spacer()
                        Text("\(personalNote.count)/500")
                            .font(.caption)
                            .foregroundColor(personalNote.count > 500 ? Color.themeDestructive : Color.themeMutedText)
                    }
                }
            }
            .navigationTitle("Edit Notes: \(placeName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let noteTrimmed = personalNote.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(wifi, power, noise, noteTrimmed.isEmpty ? nil : noteTrimmed)
                        dismiss()
                    }
                    .disabled(personalNote.count > 500)
                }
            }
        }
    }
}
