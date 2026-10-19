import XCTest
@testable import FortuneWheel

final class MapEventDataTests: XCTestCase {
    func testEveryDocumentedRouteHasTheAuditedNumberOfMapEvents() {
        XCTAssertEqual(MapEventData.events.count, 40)
        XCTAssertEqual(MapEventData.routes.map(\.id), ["Cai", "Dietrich", "Theodora", "Leda", "Part II", "Part III"])
        XCTAssertEqual(MapEventData.routes.map { MapEventData.events(for: $0.id).count }, [3, 10, 8, 7, 2, 10])
    }

    func testEveryEventHasAUniqueIDValidRouteAndAtLeastOneSource() {
        let events = MapEventData.events
        XCTAssertEqual(events.map(\.id).count, Set(events.map(\.id)).count)

        for event in events {
            XCTAssertTrue(MapEventData.routes.contains { $0.id == event.routeID }, "Unknown route for \(event.id)")
            XCTAssertFalse(event.location.isEmpty, "Missing location for \(event.id)")
            XCTAssertFalse(event.trigger.isEmpty, "Missing trigger for \(event.id)")
            XCTAssertFalse(event.sources.isEmpty, "Missing source for \(event.id)")
            XCTAssertTrue(event.sources.contains { $0.title.hasPrefix("Game8") }, "Missing Game8 source for \(event.id)")
        }
    }

    func testEventIDsExactlyMatchTheAuditedGame8Inventory() {
        let expectedIDs: Set<String> = [
            "cai-ch2-castor-centurio", "cai-ch4-bertrand-arena-underground", "cai-ch6-ahm-lu-mural",
            "dietrich-ch4-talimun-clash", "dietrich-ch4-esmeralda-inn", "dietrich-ch4-mikaela-mu",
            "dietrich-ch5-fabio-yanjin", "dietrich-ch6-alexandra", "dietrich-ch8-baozhi-clash",
            "dietrich-ch10-fabio", "dietrich-ch10-ribeira", "dietrich-ch12-answerer", "dietrich-ch12-fina",
            "theodora-ch3-bonaventure-outfit", "theodora-ch5-anatolia-inn", "theodora-ch6-bertrand",
            "theodora-ch7-alexandra", "theodora-ch10-anatolia-ship", "theodora-ch10-orchel",
            "theodora-ch11-anatolia-return", "theodora-ch12-anatolia-fleet",
            "leda-ch4-mikaela", "leda-ch4-talimun", "leda-ch5-kalla", "leda-ch6-olympia",
            "leda-ch6-alexandra", "leda-ch9-sirocco", "leda-ch10-kalla-trial",
            "part2-creek-recruitment", "part2-nathan-recruitment",
            "part3-cai", "part3-leda", "part3-theodora", "part3-dietrich", "part3-aurora-centurio",
            "part3-credna-spear", "part3-fortuna-1", "part3-fortuna-2", "part3-fortuna-3", "part3-fortuna-4"
        ]
        let eventIDs = Set(MapEventData.events.map(\.id))
        XCTAssertEqual(eventIDs, expectedIDs)

        XCTAssertEqual(MapEventData.events.filter { $0.indicator == .overworldMarker }.count, 2)
        XCTAssertEqual(MapEventData.events.filter { $0.indicator == .battleCondition }.count, 2)
        XCTAssertEqual(MapEventData.events.filter { $0.indicator == .unmarked }.count, 1)
    }

    func testFabioEventChainAndAnswererUpgradeAreDocumented() throws {
        let firstFabioScene = try XCTUnwrap(MapEventData.events.first { $0.id == "dietrich-ch5-fabio-yanjin" })
        let secondFabioScene = try XCTUnwrap(MapEventData.events.first { $0.id == "dietrich-ch10-fabio" })
        let upgradeScene = try XCTUnwrap(MapEventData.events.first { $0.id == "dietrich-ch12-answerer" })

        XCTAssertTrue(firstFabioScene.consequence?.contains("Chapter 10") == true)
        XCTAssertTrue(secondFabioScene.trigger.localizedCaseInsensitiveContains("requires"))
        XCTAssertTrue(upgradeScene.consequence?.contains("Answerer Arisen") == true)
        XCTAssertTrue(upgradeScene.sources.contains { $0.title.contains("Serenes Forest") })
    }

    func testSourceConflictsAndMissableRequirementsAreShownInsteadOfCollapsed() throws {
        let swordScene = try XCTUnwrap(MapEventData.events.first { $0.id == "cai-ch4-bertrand-arena-underground" })
        XCTAssertTrue(swordScene.trigger.contains("24 turns"))
        XCTAssertTrue(swordScene.consequence?.contains("Sword Skill increases") == true)

        let shipScene = try XCTUnwrap(MapEventData.events.first { $0.id == "theodora-ch10-anatolia-ship" })
        XCTAssertTrue(shipScene.trigger.contains("9/15"))
        XCTAssertTrue(shipScene.trigger.contains("9/21"))
        XCTAssertTrue(shipScene.consequence?.contains("Chapter 11") == true)
        XCTAssertTrue(shipScene.consequence?.contains("Chapter 12") == true)

        let bertrandMatch = try XCTUnwrap(MapEventData.events.first { $0.id == "theodora-ch6-bertrand" })
        XCTAssertTrue(bertrandMatch.location.contains("Game8"))
        XCTAssertTrue(bertrandMatch.location.contains("RPG Site"))
        XCTAssertTrue(bertrandMatch.markerNote?.contains("disagree") == true)
    }

    func testPartThreeScenesRetainTheCharacterCarryOverRequirement() {
        let carryOverEvents = MapEventData.events.filter {
            ["part3-cai", "part3-leda", "part3-theodora", "part3-dietrich"].contains($0.id)
        }
        XCTAssertEqual(carryOverEvents.count, 4)
        XCTAssertTrue(carryOverEvents.allSatisfy { $0.trigger.localizedCaseInsensitiveContains("recruit") })

        let fortunaScenes = MapEventData.events.filter { $0.id.hasPrefix("part3-fortuna") }
        XCTAssertEqual(fortunaScenes.count, 4)
        XCTAssertEqual(Set(fortunaScenes.compactMap(\.freeTime)).count, 4)
        XCTAssertTrue(fortunaScenes[2].trigger.contains("previous Fortuna event"))
        XCTAssertTrue(fortunaScenes[3].trigger.contains("previous Fortuna event"))
    }
}
