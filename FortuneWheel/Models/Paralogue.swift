import Foundation

struct ParalogueWindow: Hashable {
    let start: String
    let end: String?
    let note: String?

    init(start: String, end: String? = nil, note: String? = nil) {
        self.start = start
        self.end = end
        self.note = note
    }

    var displayText: String {
        let range: String
        if let end, end != start {
            range = "\(start) — \(end)"
        } else {
            range = start
        }

        guard let note else { return range }
        return "\(range)\n\(note)"
    }

    var accessibilityText: String {
        let range: String
        if let end, end != start {
            range = "\(start) through \(end)"
        } else {
            range = start
        }
        return note.map { "\(range), \($0)" } ?? range
    }
}

struct ParalogueOwner: Identifiable, Hashable {
    let id: String
    let name: String
    let availability: [String: ParalogueWindow]

    func window(for characterName: String) -> ParalogueWindow? {
        availability[characterName]
    }
}

struct RouteParalogue: Identifiable, Hashable {
    let id: String
    let ownerName: String
    let window: ParalogueWindow
}

struct ParalogueRoute: Identifiable, Hashable {
    let id: String
    let name: String
    let paralogues: [RouteParalogue]
}
