import Observation
import SwiftUI

@main
struct FortuneWheelApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup("Fortune Wheel", id: "main") {
            ContentView()
                .environment(appState)
        }
        .defaultSize(width: 1_080, height: 720)
        .windowResizability(.contentMinSize)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(after: .sidebar) {
                Button("Find Character…") {
                    appState.isCommandPalettePresented = true
                }
                .keyboardShortcut("k", modifiers: .command)
            }
            CommandMenu("Bird Time") {
                Button("Find Character…") {
                    appState.isCommandPalettePresented = true
                }
                .keyboardShortcut("k", modifiers: .command)
            }
        }

        Settings {
            SettingsView()
        }
    }
}

@Observable
final class AppState {
    var selectedCharacterID: String? = BirdTimeData.characters.first?.id
    var isCommandPalettePresented = false
}
