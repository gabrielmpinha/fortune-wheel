import SwiftUI

struct SettingsView: View {
    @AppStorage("showSourceNotes") private var showSourceNotes = true

    var body: some View {
        Form {
            Section("Reference") {
                Toggle("Show source notes", isOn: $showSourceNotes)
                Text("Fortune Wheel is a local reference. It does not connect to the game or send data anywhere.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
        .frame(width: 520, height: 250)
    }
}
