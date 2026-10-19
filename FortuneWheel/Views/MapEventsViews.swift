import AppKit
import SwiftUI

struct MapEventsSidebarView: View {
    @Binding var selectedRouteID: String?
    @Binding var searchText: String
    let seenEventIDs: Set<String>

    private var matchingEvents: [SecretMapEvent] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return MapEventData.events }
        return MapEventData.events.filter { $0.searchText.localizedCaseInsensitiveContains(query) }
    }

    private var matchingRoutes: [MapEventRoute] {
        MapEventData.routes.filter { route in
            matchingEvents.contains { $0.routeID == route.id }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("MAP EVENTS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(matchingEvents.count)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 7)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search characters or events", text: $searchText)
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

            if matchingRoutes.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedRouteID) {
                    let partOneRoutes = matchingRoutes.filter { $0.part == "Part I" }
                    if !partOneRoutes.isEmpty {
                        Section("Part I") {
                            ForEach(partOneRoutes) { route in
                                routeLink(route)
                            }
                        }
                    }

                    let partTwoRoutes = matchingRoutes.filter { $0.id == "Part II" }
                    if !partTwoRoutes.isEmpty {
                        Section("Part II · War Arc") {
                            ForEach(partTwoRoutes) { route in
                                routeLink(route)
                            }
                        }
                    }

                    let partThreeRoutes = matchingRoutes.filter { $0.id == "Part III" }
                    if !partThreeRoutes.isEmpty {
                        Section("Part III · Salvation") {
                            ForEach(partThreeRoutes) { route in
                                routeLink(route)
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 7) {
                Image(systemName: "circle.dotted")
                    .font(.caption)
                    .foregroundStyle(.orange)
                Text("Hidden map/story events · not supports")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.bar)
        }
    }

    private func routeLink(_ route: MapEventRoute) -> some View {
        let events = matchingEvents.filter { $0.routeID == route.id }
        let seenCount = events.filter { seenEventIDs.contains($0.id) }.count

        return NavigationLink(value: route.id) {
            HStack(spacing: 9) {
                Image(systemName: route.symbol)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.orange)
                    .frame(width: 26, height: 26)
                    .background(.orange.opacity(0.12), in: .rect(cornerRadius: 7))

                VStack(alignment: .leading, spacing: 1) {
                    Text(route.name)
                        .font(.system(size: 13, weight: .medium))
                    Text("\(events.count) events · \(seenCount) seen")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(route.name), \(events.count) map events, \(seenCount) marked seen")
        }
        .tag(route.id)
    }
}

struct MapEventsReferenceView: View {
    let routeID: String?
    let searchText: String
    let seenEventIDs: Set<String>
    let onToggleSeen: (String) -> Void

    private var selectedRoute: MapEventRoute {
        MapEventData.routes.first { $0.id == routeID } ?? MapEventData.routes[0]
    }

    private var routeEvents: [SecretMapEvent] {
        let events = MapEventData.events(for: selectedRoute.id)
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return events }
        return events.filter { $0.searchText.localizedCaseInsensitiveContains(query) }
    }

    private var seenCount: Int {
        routeEvents.filter { seenEventIDs.contains($0.id) }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                MapEventsHeader()

                VStack(alignment: .leading, spacing: 13) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedRoute.name)
                                .font(.title2.weight(.semibold))
                            Text(selectedRoute.part == "Part I" ? "Part I route" : "\(selectedRoute.id) · \(selectedRoute.part)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(seenCount) / \(routeEvents.count) seen")
                            .font(.callout.monospacedDigit().weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    CoverageNote()

                    if routeEvents.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                            .frame(maxWidth: .infinity, minHeight: 210)
                    } else {
                        LazyVStack(spacing: 11) {
                            ForEach(routeEvents) { event in
                                MapEventCard(
                                    event: event,
                                    isSeen: seenEventIDs.contains(event.id),
                                    onToggleSeen: { onToggleSeen(event.id) }
                                )
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 900, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.vertical, 26)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .navigationTitle("Map Events")
        .navigationSubtitle("Optional scenes and hidden requirements")
    }
}

private struct MapEventsHeader: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.orange)
                .frame(width: 52, height: 52)
                .background(.orange.opacity(0.13), in: .rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text("Map events & hidden scenes")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("40 documented entries across Parts I, II and III")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct CoverageNote: View {
    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                Text("This reference covers missable story scenes and hidden events—not Support conversations, paralogues, or ordinary sidequests.")
                Text("The Game8 inventory includes glowing city-map markers, blue overworld markers, two Part II battle-recruitment conditions, an explicitly unmarked Leda trial, and linked or automatic scenes. Each card identifies its marker type so non-pulsing entries are easy to distinguish.")
                Text("Coverage was cross-checked against Game8, the four Part I route walkthroughs, RPG Site's Part III walkthrough, and Serenes Forest. Dates use month/day as shown in the guides.")
                Text("Mark scenes as seen to keep a checklist on this Mac. Dates use month/day as shown in the game guides.")
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 7)
        } label: {
            Label("Scope & source coverage", systemImage: "checkmark.seal")
                .font(.callout.weight(.medium))
        }
        .padding(12)
        .background(Color.primary.opacity(0.035), in: .rect(cornerRadius: 10))
    }
}

private struct MapEventCard: View {
    let event: SecretMapEvent
    let isSeen: Bool
    let onToggleSeen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(event.chapterLabel.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.75)
                        .foregroundStyle(.orange)
                    Text(event.chapterTitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Button(action: onToggleSeen) {
                    Label(isSeen ? "Seen" : "Mark seen", systemImage: isSeen ? "checkmark.circle.fill" : "circle")
                        .font(.caption.weight(.medium))
                }
                .buttonStyle(.bordered)
                .tint(isSeen ? .green : .secondary)
                .controlSize(.small)
                .accessibilityLabel(isSeen ? "Mark \(event.title) as unseen" : "Mark \(event.title) as seen")
            }

            Text(event.title)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .textSelection(.enabled)

            if !event.characters.isEmpty {
                HStack(spacing: 6) {
                    ForEach(event.characters, id: \.self) { character in
                        Text(character)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.82))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(Color.primary.opacity(0.055), in: Capsule())
                    }
                }
            }

            EventDetailRow(title: "Location", text: event.location, symbol: "mappin")
            EventDetailRow(title: "Map signal", text: event.indicator.label, symbol: event.indicator.symbol, tint: event.indicator == .unconfirmed ? .orange : .secondary)
            EventDetailRow(title: "How to trigger", text: event.trigger, symbol: "sparkle")

            if let consequence = event.consequence {
                EventDetailRow(title: "Effect", text: consequence, symbol: "arrow.up.forward.circle", tint: .green)
            }

            if let markerNote = event.markerNote {
                Label {
                    Text(markerNote)
                        .fixedSize(horizontal: false, vertical: true)
                } icon: {
                    Image(systemName: "info.circle")
                }
                .font(.caption)
                .foregroundStyle(.orange)
            }

            HStack(spacing: 8) {
                Image(systemName: "link")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                ForEach(Array(event.sources.enumerated()), id: \.element.id) { index, source in
                    if index > 0 {
                        Text("·").foregroundStyle(.tertiary)
                    }
                    Link(source.title, destination: source.url)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
            .padding(.top, 2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSeen ? Color.green.opacity(0.035) : Color.primary.opacity(0.025), in: .rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSeen ? Color.green.opacity(0.2) : Color.primary.opacity(0.09), lineWidth: 1)
        }
    }
}

private struct EventDetailRow: View {
    let title: String
    let text: String
    let symbol: String
    var tint: Color = .secondary

    var body: some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: symbol)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 16)
                .padding(.top, 2)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 88, alignment: .leading)
            Text(text)
                .font(.callout)
                .foregroundStyle(.primary)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
