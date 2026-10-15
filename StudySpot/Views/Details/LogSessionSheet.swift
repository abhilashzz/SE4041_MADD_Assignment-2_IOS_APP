import SwiftUI

public struct LogSessionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var draft: StudySessionDraft
    @State private var validationError: String? = nil
    let isEditing: Bool
    let onSave: (StudySessionDraft) -> Void
    
    public init(draft: StudySessionDraft, isEditing: Bool = false, onSave: @escaping (StudySessionDraft) -> Void) {
        _draft = State(initialValue: draft)
        self.isEditing = isEditing
        self.onSave = onSave
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                if let error = validationError {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color.themeDestructive)
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(Color.themeDestructive)
                        }
                    }
                }
                
                Section(header: Text("Study Place")) {
                    Text(draft.placeName)
                        .font(.headline)
                        .foregroundColor(Color.themeMainText)
                }
                
                Section(header: Text("Session Details")) {
                    DatePicker("Date & Time", selection: $draft.completedAt, displayedComponents: [.date, .hourAndMinute])
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text("\(draft.durationMinutes) min")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.themePrimary)
                        }
                        
                        // Preset chips
                        HStack(spacing: 8) {
                            ForEach([30, 45, 60, 90, 120], id: \.self) { mins in
                                Button("\(mins)m") {
                                    draft.durationMinutes = mins
                                }
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(draft.durationMinutes == mins ? Color.themePrimary : Color.themeMint)
                                .foregroundColor(draft.durationMinutes == mins ? .white : Color.themeMainText)
                                .clipShape(Capsule())
                            }
                        }
                        
                        Stepper("", value: $draft.durationMinutes, in: 1...240, step: 5)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Focus Rating (1 - 5 Stars)")) {
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                draft.focusRating = star
                            }) {
                                Image(systemName: star <= draft.focusRating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(star <= draft.focusRating ? Color.themeWarmAccent : Color.themeMutedText.opacity(0.4))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("\(star) star\(star > 1 ? "s" : "")")
                        }
                        
                        Spacer()
                        
                        Text("\(draft.focusRating)/5 Focus")
                            .font(.subheadline)
                            .foregroundColor(Color.themeMutedText)
                    }
                    .padding(.vertical, 6)
                }
                
                Section(header: Text("Session Note (Optional)")) {
                    TextField("What did you accomplish?", text: $draft.note)
                        .font(.body)
                }
            }
            .navigationTitle(isEditing ? "Edit Study Session" : "Log Study Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        switch draft.validate() {
                        case .failure(let error):
                            validationError = error.localizedDescription
                        case .success:
                            onSave(draft)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
