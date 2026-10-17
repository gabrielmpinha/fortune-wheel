import AppKit
import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @SceneStorage("selectedCharacterID") private var selectedCharacterID: String?
    @AppStorage("showSourceNotes") private var showSourceNotes = true
    @State private var searchText = ""
    @State private var selectedResponseID: UUID?

    private var filteredCharacters: [BirdTimeCharacter] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return BirdTimeData.characters }
        return BirdTimeData.characters.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    private var selectedCharacter: BirdTimeCharacter? {
        BirdTimeData.characters.first { $0.id == selectedCharacterID }
            ?? BirdTimeData.characters.first
    }

    var body: some View {
        @Bindable var appState = appState

        NavigationSplitView {
            SidebarView(
                characters: filteredCharacters,
                selectedCharacterID: $selectedCharacterID,
                searchText: $searchText
            )
            .navigationSplitViewColumnWidth(min: 220, ideal: 250, max: 320)
        } detail: {
            if let selectedCharacter {
                CharacterDetailView(character: selectedCharacter, selectedResponseID: $selectedResponseID)
            } else {
                ContentUnavailableView("No Character Selected", systemImage: "bird", description: Text("Choose a character to see their Bird Time responses."))
            }
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "bird.fill")
                        .foregroundStyle(.teal)
                    Text("Fortune Wheel")
                        .font(.headline)
                }
                .accessibilityAddTraits(.isHeader)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    appState.isCommandPalettePresented = true
                } label: {
                    Label("Find Character", systemImage: "command")
                }
                .labelStyle(.iconOnly)
                .help("Find Character (⌘K)")
                .accessibilityLabel("Find character")
            }
        }
        .sheet(isPresented: $appState.isCommandPalettePresented) {
            CharacterCommandPalette(selectedCharacterID: $selectedCharacterID, searchText: $searchText)
        }
        .onAppear {
            if selectedCharacterID == nil {
                selectedCharacterID = BirdTimeData.characters.first?.id
            }
        }
        .overlay(alignment: .bottom) {
            if showSourceNotes {
                SourceNoteView()
                    .padding(.bottom, 10)
                    .padding(.horizontal, 16)
                    .allowsHitTesting(false)
            }
        }
    }

}

private struct SidebarView: View {
    let characters: [BirdTimeCharacter]
    @Binding var selectedCharacterID: String?
    @Binding var searchText: String

    private var flameLords: [BirdTimeCharacter] { characters.filter { $0.category == .flameLord } }
    private var recruits: [BirdTimeCharacter] { characters.filter { $0.category == .recruit } }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("BIRD TIME")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(characters.count)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 5)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search characters", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .help("Clear search")
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(Color(nsColor: .textBackgroundColor), in: .rect(cornerRadius: 7))
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.primary.opacity(0.12), lineWidth: 1)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 7)

            if characters.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedCharacterID) {
                    if !flameLords.isEmpty {
                        CharacterSection(title: CharacterCategory.flameLord.rawValue, characters: flameLords)
                    }
                    if !recruits.isEmpty {
                        CharacterSection(title: CharacterCategory.recruit.rawValue, characters: recruits)
                    }
                }
                .listStyle(.sidebar)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 7) {
                Image(systemName: "magnifyingglass")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Quick switch")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("⌘K")
                    .font(.caption2.monospaced())
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.bar)
        }
    }

    @ViewBuilder
    private func CharacterSection(title: String, characters: [BirdTimeCharacter]) -> some View {
        Section(title) {
            ForEach(characters) { character in
                NavigationLink(value: character.id) {
                    CharacterListRow(character: character)
                }
                .tag(character.id)
                .contextMenu {
                    Button("Copy Character Name") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(character.name, forType: .string)
                    }
                }
            }
        }
    }
}

private struct CharacterListRow: View {
    let character: BirdTimeCharacter

    var body: some View {
        HStack(spacing: 9) {
            CharacterAvatar(character: character, size: 26)
            VStack(alignment: .leading, spacing: 1) {
                Text(character.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                Text(character.responses.isEmpty ? "Not verified" : "\(character.verifiedCount) verified")
                    .font(.system(size: 10))
                    .foregroundStyle(character.hasCompleteData ? Color.secondary : Color.orange)
            }
            Spacer(minLength: 0)
            if character.hasCompleteData {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .help("All published prompts have a verified answer")
            } else {
                Image(systemName: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .help("This character has incomplete published data")
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(character.name), \(character.responses.isEmpty ? "no verified responses" : "\(character.verifiedCount) verified responses")")
    }
}

private struct CharacterDetailView: View {
    let character: BirdTimeCharacter
    @Binding var selectedResponseID: UUID?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    CharacterHeader(character: character)

                    if character.responses.isEmpty {
                        IncompleteDataCard(character: character)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Correct reactions")
                                    .font(.title3.weight(.semibold))
                                Spacer()
                                Text("\(character.verifiedCount) of \(character.responses.count)")
                                    .font(.callout.monospacedDigit())
                                    .foregroundStyle(character.hasCompleteData ? Color.secondary : Color.orange)
                            }

                            ForEach(Array(character.responses.enumerated()), id: \.element.id) { index, response in
                                ResponseCard(
                                    index: index + 1,
                                    response: response,
                                    isSelected: selectedResponseID == response.id,
                                    onSelect: { selectedResponseID = response.id }
                                )
                                .id(response.id)
                            }
                        }
                    }
                }
                .frame(maxWidth: 820, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .background(Color(nsColor: .windowBackgroundColor))
            .onChange(of: selectedResponseID) { _, newValue in
                guard let newValue else { return }
                withAnimation(.snappy) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .navigationTitle(character.name)
        .navigationSubtitle("Bird Time reference")
    }
}

private struct CharacterHeader: View {
    let character: BirdTimeCharacter

    var body: some View {
        HStack(spacing: 16) {
            CharacterAvatar(character: character, size: 68)
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                HStack(spacing: 8) {
                    Label(character.category.rawValue, systemImage: character.category == .flameLord ? "crown" : "person.2")
                    Text("•")
                    Label("One answer per prompt", systemImage: "checkmark.seal")
                }
                .font(.callout)
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }
}

private struct ResponseCard: View {
    let index: Int
    let response: BirdTimeResponse
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var isHovered = false
    @State private var copied = false

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 14) {
                Text("\(index)")
                    .font(.caption.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .frame(width: 22, alignment: .trailing)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 13) {
                    Text(response.prompt)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)

                    HStack(spacing: 8) {
                        if let reaction = response.reaction {
                            Image(systemName: reaction.systemImage)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(reaction.tint)
                                .frame(width: 25, height: 25)
                                .background(reaction.tint.opacity(0.13), in: .circle)
                            Text(reaction.rawValue)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(reaction.tint)
                            Spacer()
                            if isHovered || isSelected {
                                Button {
                                    copy(reaction.rawValue)
                                } label: {
                                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                        .font(.caption)
                                }
                                .buttonStyle(.borderless)
                                .foregroundStyle(.secondary)
                                .help(copied ? "Copied" : "Copy answer")
                            }
                        } else {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.orange)
                            Text("Answer not verified yet")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.orange)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.accentColor.opacity(0.11) : (isHovered ? Color.primary.opacity(0.035) : Color.clear), in: .rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor.opacity(0.36) : Color.primary.opacity(0.08), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(response.reaction.map { "\(response.prompt). Correct reaction: \($0.rawValue)" } ?? "\(response.prompt). Answer not verified yet")
    }

    private func copy(_ value: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(value, forType: .string)
        copied = true
        Task {
            try? await Task.sleep(for: .seconds(1.4))
            copied = false
        }
    }
}

private struct IncompleteDataCard: View {
    let character: BirdTimeCharacter

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("No verified Bird Time prompts yet", systemImage: "hourglass")
                .font(.headline)
                .foregroundStyle(.orange)
            Text("The public guides checked for this build do not yet include a verified question-and-answer set for \(character.name). This entry is kept visible so it is not mistaken for a missing character.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.orange.opacity(0.08), in: .rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.orange.opacity(0.22), lineWidth: 1)
        }
    }
}

private struct CharacterAvatar: View {
    let character: BirdTimeCharacter
    let size: CGFloat

    private var colors: [Color] {
        let palettes: [[Color]] = [
            [.teal, .blue], [.indigo, .purple], [.orange, .pink], [.green, .teal], [.blue, .cyan]
        ]
        let index = abs(character.name.unicodeScalars.reduce(0) { $0 + Int($1.value) }) % palettes.count
        return palettes[index]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: character.category == .flameLord ? "crown.fill" : "person.fill")
                .font(.system(size: size * 0.34, weight: .bold))
                .foregroundStyle(.white.opacity(0.92))
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: size * 0.28))
        .overlay {
            RoundedRectangle(cornerRadius: size * 0.28)
                .stroke(.white.opacity(0.22), lineWidth: 1)
        }
        .shadow(color: colors[0].opacity(0.18), radius: 5, y: 2)
        .accessibilityHidden(true)
    }
}

private struct CharacterCommandPalette: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCharacterID: String?
    @Binding var searchText: String
    @State private var query = ""
    @FocusState private var isSearchFocused: Bool

    private var results: [BirdTimeCharacter] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return BirdTimeData.characters }
        return BirdTimeData.characters.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Find a character", text: $query)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .focused($isSearchFocused)
                    .onSubmit { selectFirst() }
                Text("ESC")
                    .font(.caption2.monospaced().weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)

            Divider()

            if results.isEmpty {
                ContentUnavailableView.search(text: query)
                    .frame(height: 220)
            } else {
                List(results) { character in
                    Button {
                        selectedCharacterID = character.id
                        searchText = ""
                        dismiss()
                    } label: {
                        HStack(spacing: 10) {
                            CharacterAvatar(character: character, size: 28)
                            Text(character.name)
                            Spacer()
                            Text(character.category == .flameLord ? "Flame Lord" : "Recruit")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .frame(width: 560, height: 470)
        .onAppear { isSearchFocused = true }
    }

    private func selectFirst() {
        guard let first = results.first else { return }
        selectedCharacterID = first.id
        searchText = ""
        dismiss()
    }
}

private struct SourceNoteView: View {
    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "info.circle")
            Text("Fan reference • dialogue and reactions are kept in English to match the game")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 11)
        .padding(.vertical, 7)
        .background(.regularMaterial, in: .capsule)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }
}
