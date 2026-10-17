import XCTest
@testable import FortuneWheel

final class BirdTimeDataTests: XCTestCase {
    func testEveryPublishedCharacterIsPresentExactlyOnce() {
        let characters = BirdTimeData.characters
        XCTAssertEqual(Set(characters.map(\.name)), Set(BirdTimeData.expectedCharacterNames))
        XCTAssertEqual(characters.count, BirdTimeData.expectedCharacterNames.count)
        XCTAssertEqual(characters.map(\.id).count, Set(characters.map(\.id)).count)
    }

    func testNoCharacterContainsDuplicatePrompts() {
        for character in BirdTimeData.characters {
            let prompts = character.responses.map(\.prompt)
            XCTAssertEqual(prompts.count, Set(prompts).count, "Duplicate prompt in \(character.name)")
        }
    }

    func testEveryKnownResponseHasAReaction() {
        let incomplete = BirdTimeData.characters.filter { !$0.hasCompleteData }.map(\.name)
        XCTAssertEqual(Set(incomplete), ["Gaitz", "Seteth"])

        for character in BirdTimeData.characters where character.name != "Gaitz" && character.name != "Seteth" {
            XCTAssertFalse(character.responses.isEmpty, "Missing responses for \(character.name)")
            XCTAssertTrue(character.responses.allSatisfy(\.isVerified), "Unverified response in \(character.name)")
        }
    }

    func testResponseCountsMatchTheReviewedSourceSet() {
        let expectedCounts: [String: Int] = [
            "Cai": 10, "Dietrich": 10, "Theodora": 10, "Leda": 10,
            "Alexandra": 10, "Benditz": 9, "Bonaventure": 10, "Buccar": 10,
            "Catania": 10, "Dadao": 9, "Dante": 10, "Diego": 10,
            "Esmeralda": 10, "Fabio": 10, "Fianna": 10, "Goliath": 9,
            "Gaitz": 0, "Guzran": 10, "Halvin": 10, "Inyoni": 9,
            "Io": 10, "Jasmine": 10, "Jester": 10, "Kiroc": 10,
            "Lilian": 10, "Loretta": 10, "Ludia": 10, "Lysander": 10,
            "Majide": 10, "Mikaela": 10, "Mu": 10, "Nezha": 8,
            "Ninae": 9, "Noctula": 10, "Nuzzuo": 10, "Nydine": 8,
            "Olympia": 10, "Peppe": 9, "Peter": 10, "Seteth": 9,
            "Sha Lan": 10, "Simon": 10, "Sirocco": 10, "Sofia": 10,
            "Tialla": 10, "Tobias": 10, "Ultand": 10, "Ursula": 10,
            "Yang Jie": 9, "Zarcone": 10
        ]

        let actualCounts = Dictionary(uniqueKeysWithValues: BirdTimeData.characters.map { ($0.name, $0.responses.count) })
        XCTAssertEqual(actualCounts, expectedCounts)
    }

    func testParalogueAvailabilityMatchesReviewedSourceSet() {
        XCTAssertEqual(ParalogueData.participants, ["Cai", "Dietrich", "Theodora", "Leda"])
        XCTAssertEqual(ParalogueData.owners.map(\.name), [
            "Leda", "Theodora", "Bertrand", "Talimun", "Solel", "Anatolia", "Cai", "Dietrich", "Orchel"
        ])

        for owner in ParalogueData.owners {
            XCTAssertTrue(
                Set(owner.availability.keys).isSubset(of: Set(ParalogueData.participants)),
                "Unknown participant in \(owner.name)'s paralogue"
            )
        }

        let leda = try! XCTUnwrap(ParalogueData.owners.first { $0.name == "Leda" })
        XCTAssertEqual(leda.window(for: "Dietrich"), ParalogueWindow(start: "9/2", end: "9/8"))

        let bertrand = try! XCTUnwrap(ParalogueData.owners.first { $0.name == "Bertrand" })
        XCTAssertEqual(bertrand.window(for: "Dietrich"), ParalogueWindow(start: "9/17", note: "One day only"))

        XCTAssertEqual(ParalogueData.routes.map(\.name), ParalogueData.participants)
        XCTAssertEqual(ParalogueData.routes.map(\.paralogues.count), [4, 8, 7, 4])
        XCTAssertEqual(
            ParalogueData.routes.first { $0.name == "Cai" }?.paralogues.map(\.ownerName),
            ["Bertrand", "Talimun", "Solel", "Orchel"]
        )
    }
}
