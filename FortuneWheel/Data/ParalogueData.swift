import Foundation

enum ParalogueData {
    static let availabilityTableID = "__availability_table__"

    /// The source uses month/day notation and does not specify a year.
    static let participants = ["Cai", "Dietrich", "Theodora", "Leda"]

    static let owners: [ParalogueOwner] = [
        owner("Leda", [
            ("Dietrich", window("9/2", "9/8")),
            ("Theodora", window("9/2", "9/8"))
        ]),
        owner("Theodora", [
            ("Dietrich", window("9/3", "9/15"))
        ]),
        owner("Bertrand", [
            ("Cai", window("9/17", "9/25")),
            ("Dietrich", window("9/17", note: "One day only")),
            ("Theodora", window("9/17", "9/25"))
        ]),
        owner("Talimun", [
            ("Cai", window("9/17", "10/12")),
            ("Dietrich", window("9/17", "10/12")),
            ("Theodora", window("9/17", "10/12"))
        ]),
        owner("Solel", [
            ("Cai", window("9/24", "10/5")),
            ("Dietrich", window("9/29", "10/5")),
            ("Theodora", window("9/24", "10/5"))
        ]),
        owner("Anatolia", [
            ("Dietrich", window("10/5", "10/17")),
            ("Leda", window("9/5", "10/17"))
        ]),
        owner("Cai", [
            ("Dietrich", window("10/16", "10/22")),
            ("Theodora", window("10/16", "10/22")),
            ("Leda", window("10/16", "10/22"))
        ]),
        owner("Dietrich", [
            ("Theodora", window("10/16", "10/24")),
            ("Leda", window("10/16", "11/1"))
        ]),
        owner("Orchel", [
            ("Cai", window("10/18", "10/21")),
            ("Dietrich", window("10/18", "10/27")),
            ("Theodora", window("10/18", "10/24")),
            ("Leda", window("10/18", "10/27"))
        ])
    ]

    static let routes: [ParalogueRoute] = participants.map { routeName in
        ParalogueRoute(
            id: routeName,
            name: routeName,
            paralogues: owners.compactMap { owner in
                guard let window = owner.window(for: routeName) else { return nil }
                return RouteParalogue(
                    id: "\(routeName)-\(owner.name)",
                    ownerName: owner.name,
                    window: window
                )
            }
        )
    }

    private static func owner(_ name: String, _ entries: [(String, ParalogueWindow)]) -> ParalogueOwner {
        ParalogueOwner(id: name, name: name, availability: Dictionary(uniqueKeysWithValues: entries))
    }

    private static func window(_ start: String, _ end: String? = nil, note: String? = nil) -> ParalogueWindow {
        ParalogueWindow(start: start, end: end, note: note)
    }
}
