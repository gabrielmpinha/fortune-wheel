import Foundation

enum MapEventData {
    static let sources: [MapEventSource] = [
        MapEventSource(
            title: "RPG Site — Cai's Path",
            url: URL(string: "https://www.rpgsite.net/guide/21213-fire-emblem-fortunes-weave-part-i-cais-path-walkthrough")!
        ),
        MapEventSource(
            title: "RPG Site — Dietrich's Path",
            url: URL(string: "https://www.rpgsite.net/guide/21212-fire-emblem-fortunes-weave-part-i-dietrichs-path-walkthrough")!
        ),
        MapEventSource(
            title: "RPG Site — Leda's Path",
            url: URL(string: "https://www.rpgsite.net/guide/21210-fire-emblem-fortunes-weave-part-i-ledas-path-walkthrough")!
        ),
        MapEventSource(
            title: "RPG Site — Theodora's Path",
            url: URL(string: "https://www.rpgsite.net/guide/21211-fire-emblem-fortunes-weave-part-i-theodoras-path-walkthrough")!
        ),
        MapEventSource(
            title: "RPG Site — Part III: Salvation",
            url: URL(string: "https://www.rpgsite.net/guide/21433-fire-emblem-fortunes-weave-part-iii-salvation-walkthrough")!
        ),
        MapEventSource(
            title: "Serenes Forest — Missable Events",
            url: URL(string: "https://serenesforest.net/fortunes-weave/miscellaneous/missable-events/")!
        ),
        MapEventSource(
            title: "Game8 — All Missable Cutscenes and Hidden Events",
            url: URL(string: "https://game8.co/games/Fire-Emblem-Fortunes-Weave/archives/629932")!
        )
    ]

    static let routes: [MapEventRoute] = [
        MapEventRoute(id: "Cai", name: "Cai", part: "Part I", symbol: "sun.max.fill"),
        MapEventRoute(id: "Dietrich", name: "Dietrich", part: "Part I", symbol: "flame.fill"),
        MapEventRoute(id: "Theodora", name: "Theodora", part: "Part I", symbol: "crown.fill"),
        MapEventRoute(id: "Leda", name: "Leda", part: "Part I", symbol: "wind"),
        MapEventRoute(id: "Part II", name: "Part II", part: "War Arc", symbol: "shield.lefthalf.filled"),
        MapEventRoute(id: "Part III", name: "Part III", part: "Salvation", symbol: "sparkles")
    ]

    static let events: [SecretMapEvent] = [
        // Cai — Part I
        event("cai-ch2-castor-centurio", "Cai", "Part I", 2, "Road to the Capital", nil,
              "Castor and Centurio in eastern Dagsion", ["Castor", "Centurio"], "East side of Dagsion",
              "Before returning to the inn, head to the bottom of the stairs on the east side of Dagsion.", nil,
              "This is listed among Cai's tracked optional scenes.", [.cai]),
        event("cai-ch4-bertrand-arena-underground", "Cai", "Part I", 4, "Festival of the Strong", nil,
              "Bertrand at the Arena Underground", ["Bertrand", "Cai"], "Arena Underground",
              "Talk to Bertrand as soon as Free Time starts; the chapter has only 24 turns.", "Cai's Sword Skill increases.", nil, [.cai]),
        event("cai-ch6-ahm-lu-mural", "Cai", "Part I", 6, "To the Land of Cybele", nil,
              "The mural in Ahm Lu", ["Tialla", "Cai"], "Mural in Ahm Lu",
              "Speak to Tialla in Ahm Lu, then examine the mural before activating the Main Quest marker; examining the mural directly also works.", nil,
              "Optional scene during the Main Quest exploration; the source does not identify a separate pulsing marker.", [.cai], indicator: .unconfirmed),

        // Dietrich — Part I
        event("dietrich-ch4-talimun-clash", "Dietrich", "Part I", 4, "Brute Force", nil,
              "Talimun's Lowtown scene and follow-up clash", ["Talimun", "Order of Mithras"], "Southern Lowtown, then Lowtown at night",
              "After the Tavern events, go to the southern map pulse. Seeing Talimun's scene enables a later Event Clash after registration.",
              "Follow-up Event Clash with the Order of Mithras.", nil, [.dietrich, .serenes]),
        event("dietrich-ch4-esmeralda-inn", "Dietrich", "Part I", 4, "Brute Force", "Free Time 1",
              "Esmeralda at the inn", ["Esmeralda"], "Back of the city inn",
              "Visit the inn during the first Free Time.", nil, "Optional scene; no additional prerequisite is documented.", [.dietrich, .serenes]),
        event("dietrich-ch4-mikaela-mu", "Dietrich", "Part I", 4, "Brute Force", "Free Time 1",
              "Mikaela, Esmeralda, and Mu", ["Mikaela", "Esmeralda", "Mu"], "Arena, then Shopping Arcade",
              "Talk to Mikaela and Esmeralda by the Arena, then follow them to the shopping area.", nil,
              "Optional scene chain. The sources do not state a separate map-pulse requirement.", [.dietrich, .serenes]),
        event("dietrich-ch5-fabio-yanjin", "Dietrich", "Part I", 5, "The Essence of a Warrior", "Free Time 2",
              "Fabio and Yanjin in the eastern alleys", ["Fabio", "Yanjin"], "Eastern alley in Midtown",
              "Speak to Fabio in Temple Row after Free Time begins, then follow him to the eastern alley in Midtown.",
              "This event is the prerequisite for Fabio's Chapter 10 scene.", nil, [.dietrich, .serenes]),
        event("dietrich-ch6-alexandra", "Dietrich", "Part I", 6, "Instinct and Reason", "Free Time 2",
              "Alexandra's Lowtown event", ["Alexandra"], "Midtown, then Lowtown",
              "Talk to Alexandra in Midtown, then go to the pulsing event in Lowtown.", nil, nil, [.dietrich, .serenes]),
        event("dietrich-ch8-baozhi-clash", "Dietrich", "Part I", 8, "Cetus the Sea Tyrant", "Free Time 4",
              "The Lowtown warehouse at night", ["Baozhi"], "Lowtown alley / southeast warehouse",
              "Go to the pulsing marker at 18:00 (6 p.m.) on any available day.",
              "Event Clash with Baozhi and an optional scene.", nil, [.dietrich, .serenes]),
        event("dietrich-ch10-fabio", "Dietrich", "Part I", 10, "The Mediator of Nuwa", "Free Time 6",
              "Fabio near Temple Row", ["Fabio"], "Southwest of Upper Temple Row",
              "Go between 18:00 and 23:59; requires the Fabio scene from Chapter 5.", nil,
              "Serenes Forest gives the 18:00–midnight window. RPG Site describes the scene as at 18:00.", [.dietrich, .serenes]),
        event("dietrich-ch10-ribeira", "Dietrich", "Part I", 10, "The Mediator of Nuwa", "Free Time",
              "Myson and Cleobulus in Ribeira", ["Myson", "Cleobulus"], "Ribeira on the world map",
              "After Free Time begins, travel to Ribeira and speak to the two hidden characters.", nil,
              "Blue overworld marker; this is not a Dagsion city-map pulse.", [.dietrich], indicator: .overworldMarker),
        event("dietrich-ch12-answerer", "Dietrich", "Part I", 12, "Mars, Bringer of War", "Free Time 8",
              "Fabio and Answerer", ["Fabio", "Dietrich"], "Alley east of the markets",
              "After Free Time begins, speak to Fabio in the alley east of Midtown before the Chapter 12 Main Quest battle.",
              "Answerer upgrades to Answerer Arisen during the Main Quest battle. No Chapter 5 or 10 prerequisite is listed for this upgrade.", nil,
              [.dietrich, .serenes]),
        event("dietrich-ch12-fina", "Dietrich", "Part I", 12, "Mars, Bringer of War", "Free Time",
              "Myson and Cleobulus in Fina", ["Myson", "Cleobulus"], "Fina on the world map",
              "After Free Time begins, travel to Fina and speak to the two hidden characters.", nil,
              "Blue overworld marker; this is not a Dagsion city-map pulse.", [.dietrich], indicator: .overworldMarker),

        // Theodora — Part I
        event("theodora-ch3-bonaventure-outfit", "Theodora", "Part I", 3, "Tumult at the Imperial Capital", nil,
              "Bonaventure and Theodora's outfit", ["Bonaventure", "Theodora"], "Dagsion",
              "Speak to Bonaventure before exploring Dagsion in Chapter 3.", "Unlocks Theodora's casual outfit.",
              "The guide describes this as a hidden event but does not specify a pulsing marker.", [.theodora], indicator: .unconfirmed),
        event("theodora-ch5-anatolia-inn", "Theodora", "Part I", 5, "An Ominous Clash", "Free Time 2",
              "Anatolia in Midtown", ["Anatolia"], "East side of Midtown, near the Inn",
              "Find the optional scene during the Chapter 5 Free Time.", nil,
              "The route guide explicitly groups this under slow-pulse optional scenes.", [.theodora]),
        event("theodora-ch6-bertrand", "Theodora", "Part I", 6, "The Treasure Hunter", nil,
              "The special match with Bertrand", ["Bertrand", "Theodora"], "Crystal Palace reception (Game8) / path between Temple Row and Hightown (RPG Site)",
              "On 4/6, Game8 says to speak to the Crystal Palace receptionist between 18:00 and 23:59; RPG Site lists the special match at 18:00 on the path between Temple Row and Hightown.",
              "After watching the scene, fight Bertrand with up to 3 units; winning grants 500 Renown.",
              "The guides disagree on the exact location; follow the in-game event indicator. Both give 4/6 at 18:00.", [.theodora], indicator: .unconfirmed),
        event("theodora-ch7-alexandra", "Theodora", "Part I", 7, "A Voice from the Darkness", "Free Time 4",
              "Alexandra's Lowtown event", ["Alexandra"], "Midtown, then Lowtown",
              "Talk to Alexandra in Midtown, then follow the pulsing event in Lowtown.", nil, nil, [.theodora]),
        event("theodora-ch10-anatolia-ship", "Theodora", "Part I", 10, "The Queen and the Merchant", "Free Time 7",
              "Anatolia asks to borrow the ship", ["Anatolia", "Theodora"], "Dagsion",
              "Talk to Anatolia near the Arena after Free Time begins. Deadline conflict: Game8 says 9/15 at 23:59; RPG Site says 9/21. Use 9/15 to be safe.",
              "Lending the ship unlocks an event when Anatolia returns in Chapter 11 and makes her fleet appear in Theodora's Chapter 12 Main Quest battle.",
              "Deadline differs between Game8 and RPG Site; the earlier date is safer. The guides do not independently specify a pulsing marker.", [.theodora], indicator: .unconfirmed),
        event("theodora-ch10-orchel", "Theodora", "Part I", 10, "The Queen and the Merchant", "Free Time 7",
              "Orchel at Yu Phas' Temple", ["Orchel"], "Yu Phas' Temple, reached from the Entertainment District",
              "Enter the Temple from the Entertainment District and find the optional scene.", nil,
              "Optional scene; no extra prerequisite is documented.", [.theodora]),
        event("theodora-ch11-anatolia-return", "Theodora", "Part I", 11, "A Sudden Turn", nil,
              "Anatolia returns to Dagsion", ["Anatolia", "Theodora"], "Dagsion",
              "Requires lending Anatolia the ship in Chapter 10. She returns at 18:00 on 9/28; be in Dagsion any time afterward during Chapter 11.", nil,
              "The guide says it triggers while in Dagsion after her return; it does not specify a pulsing marker.", [.theodora], indicator: .automatic),
        event("theodora-ch12-anatolia-fleet", "Theodora", "Part I", 12, "The War of Zanbar", nil,
              "Anatolia's fleet joins the main battle", ["Anatolia", "Theodora"], "Chapter 12 Main Quest battle",
              "Requires lending Anatolia the ship in Chapter 10.", "Anatolia's forces appear during the Main Quest battle.",
              "Automatic battle event; not a Dagsion pulsing map scene.", [.theodora], indicator: .automatic),

        // Leda — Part I
        event("leda-ch4-mikaela", "Leda", "Part I", 4, "The Indelible Past", "Free Time 1",
              "Mikaela in the Shopping Arcade", ["Mikaela"], "Shopping Arcade",
              "Look for the optional-scene pulse after Free Time begins.", nil, nil, [.leda]),
        event("leda-ch4-talimun", "Leda", "Part I", 4, "The Indelible Past", "Free Time 1",
              "Talimun by the Item Shop", ["Talimun"], "Near the Item Shop in the Shopping Arcade",
              "After spending at least one turn, go near the Item Shop in the Shopping Arcade.", nil,
              "The walkthrough marks the exact availability timing as an estimate.", [.leda]),
        event("leda-ch5-kalla", "Leda", "Part I", 5, "Women at Battle", "Free Time 2",
              "Kalla at her branch temple", ["Kalla"], "Kalla's Branch Temple",
              "Speak to Kalla at her Branch Temple after Free Time begins.", nil, nil, [.leda]),
        event("leda-ch6-olympia", "Leda", "Part I", 6, "The Soaring Maiden", "Free Time 3",
              "Olympia south of Temple Row", ["Olympia"], "South of Temple Row",
              "Speak to Olympia after Free Time begins.", nil, nil, [.leda]),
        event("leda-ch6-alexandra", "Leda", "Part I", 6, "The Soaring Maiden", "Free Time 3",
              "Alexandra's Lowtown event", ["Alexandra"], "Midtown, then Lowtown",
              "Talk to Alexandra in Midtown, then go to the pulsing event in Lowtown.", nil, nil, [.leda]),
        event("leda-ch9-sirocco", "Leda", "Part I", 9, "Discordance", "Free Time 6",
              "Sirocco's two scenes", ["Sirocco"], "Lower Temple Row, then northwest passage",
              "Between 18:00 and 23:59, approach Sirocco in Lower Temple Row, then speak to him again at the northwest passage.", nil,
              "The guide qualifies the any-day timing as an estimate.", [.leda]),

        event("leda-ch10-kalla-trial", "Leda", "Part I", 10, "A Father's Request and a Daughter's Wish", nil,
              "Kalla's hidden temple trial", ["Kalla"], "Kalla's Main Temple reception",
              "After Free Time starts, speak to the Temple Reception and accept Kalla's Trial.",
              "Win the two-part Clash to receive Kalla's Bow.",
              "Game8 explicitly says this trial is unmarked on the map; included as a hidden missable extra, not a pulsing event.", [.leda], indicator: .unmarked),

        // Part II — War Arc hidden recruitment events
        event("part2-creek-recruitment", "Part II", "Part II", 2, "Showdown at Agris Stronghold", nil,
              "Recruit Creek", ["Creek"], "Chapter 2 battle",
              "Available on Dietrich's or Leda's Part II route. Complete My Late Sister's Accessory in Part I, then defeat Creek in the Chapter 2 battle.",
              "Recruit Creek.", "Battle recruitment condition; not a Dagsion map marker.", [.partTwo], indicator: .battleCondition),
        event("part2-nathan-recruitment", "Part II", "Part II", 3, "Beyond the Salt Road", nil,
              "Recruit Nathan", ["Nathan", "Creek"], "Chapter 3 battle",
              "Available on Dietrich's or Leda's Part II route. Deal the final blow to Nathan with Creek; Creek must have been recruited through the Chapter 2 event.",
              "Recruit Nathan.", "Battle recruitment condition linked to the Chapter 2 event; not a Dagsion map marker.", [.partTwo], indicator: .battleCondition),

        // Part III — route carry-over scenes and Fortuna scenes
        event("part3-cai", "Part III", "Part III", nil, "Second Section: True Strength", "Free Time 1",
              "Cai in Midtown", ["Cai"], "East side of Midtown",
              "Complete Cai's route through Part II, recruit him in Part III, then approach him during the Second Section: True Strength.", nil, nil, [.partThree]),
        event("part3-leda", "Part III", "Part III", nil, "Second Section: True Strength", "Free Time 1",
              "Leda at Arena Plaza", ["Leda"], "Fountain near Arena Plaza in Midtown",
              "Complete Leda's route through Part II, recruit her in Part III, then approach her during the Second Section: True Strength.", nil, nil, [.partThree]),
        event("part3-theodora", "Part III", "Part III", nil, "Second Section: True Strength", "Free Time 1",
              "Theodora near Perch", ["Theodora"], "Guesthouse area of Perch in Hightown",
              "Complete Theodora's route through Part II, recruit her in Part III, then approach her during the Second Section: True Strength.", nil, nil, [.partThree]),
        event("part3-dietrich", "Part III", "Part III", nil, "Second Section: True Strength", "Free Time 1",
              "Dietrich on the Lowtown port road", ["Dietrich"], "Path leading to the Port in Lowtown",
              "Complete Dietrich's route through Part II, recruit him in Part III, then approach him during the Second Section: True Strength.", nil, nil, [.partThree]),
        event("part3-aurora-centurio", "Part III", "Part III", nil, "True Strength", "Free Time",
              "Aurora after rescuing Centurio", ["Aurora", "Centurio"], "Dagsion, south of Temple Row",
              "Complete the Rescue Centurio quest, speak to Centurio in Dagsion, then speak to Aurora south of Temple Row.", nil,
              "Hidden quest-linked event; the guide does not state a pulsing marker.", [.partThree], indicator: .unconfirmed),
        event("part3-credna-spear", "Part III", "Part III", nil, "True Strength", "Free Time",
              "Credna upgrades Nameless", ["Credna"], "Credna's branch temple in Dagsion",
              "Complete Credna's Request, then return to Dagsion and speak to Credna. This remains available in later Sections.",
              "Upgrades Eshmel's Nameless Spear to the Shining Spear.",
              "Hidden quest-linked interaction; the guide does not state a pulsing marker.", [.partThree], indicator: .unconfirmed),
        event("part3-fortuna-1", "Part III", "Part III", nil, "Second Section: True Strength", "Free Time 1",
              "Fortuna near the Thermae · Section 2", ["Fortuna"], "Near the Thermae",
              "Approach Fortuna after Free Time begins in the Second Section: True Strength (2/1–2/10).", nil, nil, [.partThree]),
        event("part3-fortuna-2", "Part III", "Part III", nil, "Third Section: The Inheritors", "Free Time 2",
              "Fortuna near the Thermae · Section 3", ["Fortuna"], "Near the Thermae",
              "Approach Fortuna after Free Time begins in the Third Section: The Inheritors (2/16–2/25).", nil, nil, [.partThree]),
        event("part3-fortuna-3", "Part III", "Part III", nil, "Fourth Section: The Hopes of Monarchs and of People", "Free Time 3",
              "Fortuna near the Thermae · Section 4", ["Fortuna"], "Near the Thermae",
              "Approach Fortuna after Free Time begins in the Fourth Section: The Hopes of Monarchs and of People (3/7–3/21); requires seeing the previous Fortuna event.", nil, nil, [.partThree]),
        event("part3-fortuna-4", "Part III", "Part III", nil, "Fifth Section: Song of the Living", "Free Time 4",
              "Fortuna near the Thermae · Section 5", ["Fortuna"], "Near the Thermae",
              "Approach Fortuna after Free Time begins in the Fifth Section: Song of the Living (4/6–4/25); requires seeing the previous Fortuna event.", nil, nil, [.partThree])
    ]

    static func events(for routeID: String) -> [SecretMapEvent] {
        events.filter { $0.routeID == routeID }
    }

    private enum SourceID {
        case cai, dietrich, theodora, leda, partTwo, partThree, serenes
    }

    private static func event(
        _ id: String,
        _ routeID: String,
        _ part: String,
        _ chapter: Int?,
        _ chapterTitle: String,
        _ freeTime: String?,
        _ title: String,
        _ characters: [String],
        _ location: String,
        _ trigger: String,
        _ consequence: String?,
        _ markerNote: String?,
        _ sourceIDs: [SourceID],
        indicator: MapEventIndicator = .pulsingMap
    ) -> SecretMapEvent {
        let sourcesByID: [SourceID: Int] = [
            .cai: 0, .dietrich: 1, .leda: 2, .theodora: 3, .partThree: 4, .serenes: 5, .partTwo: 6
        ]
        var linkedSources = sourceIDs.map { sources[sourcesByID[$0]!] }
        if !linkedSources.contains(sources[6]) {
            linkedSources.append(sources[6])
        }
        return SecretMapEvent(
            id: id,
            routeID: routeID,
            part: part,
            chapter: chapter,
            chapterTitle: chapterTitle,
            freeTime: freeTime,
            title: title,
            characters: characters,
            location: location,
            trigger: trigger,
            indicator: indicator,
            consequence: consequence,
            markerNote: markerNote,
            sources: linkedSources
        )
    }

}
