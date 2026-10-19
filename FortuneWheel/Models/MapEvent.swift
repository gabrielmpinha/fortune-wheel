import Foundation

struct MapEventSource: Hashable, Identifiable {
    let title: String
    let url: URL

    var id: URL { url }
}

struct SecretMapEvent: Identifiable, Hashable {
    let id: String
    let routeID: String
    let part: String
    let chapter: Int?
    let chapterTitle: String
    let freeTime: String?
    let title: String
    let characters: [String]
    let location: String
    let trigger: String
    let indicator: MapEventIndicator
    let consequence: String?
    let markerNote: String?
    let sources: [MapEventSource]

    var chapterLabel: String {
        var label = part
        if let chapter {
            label += " · Chapter \(chapter)"
        }
        if let freeTime {
            label += " · \(freeTime)"
        }
        return label
    }

    var searchText: String {
        [
            title, routeID, part, chapter.map(String.init), chapterTitle, freeTime,
            characters.joined(separator: " "), location, trigger, consequence, markerNote
        ]
        .compactMap { $0 }
        .joined(separator: " ")
    }
}

enum MapEventIndicator: String, Hashable {
    case pulsingMap
    case overworldMarker
    case battleCondition
    case unmarked
    case automatic
    case unconfirmed

    var label: String {
        switch self {
        case .pulsingMap: "Pulsing city-map marker"
        case .overworldMarker: "Blue overworld marker"
        case .battleCondition: "Battle recruitment condition"
        case .unmarked: "No map marker"
        case .automatic: "Automatic story scene"
        case .unconfirmed: "Marker type not confirmed"
        }
    }

    var symbol: String {
        switch self {
        case .pulsingMap: "circle.dotted"
        case .overworldMarker: "globe.americas.fill"
        case .battleCondition: "flag.fill"
        case .unmarked: "circle.slash"
        case .automatic: "play.fill"
        case .unconfirmed: "questionmark.circle"
        }
    }
}

struct MapEventRoute: Identifiable, Hashable {
    let id: String
    let name: String
    let part: String
    let symbol: String
}
