import Foundation
import SwiftUI

enum CharacterCategory: String, CaseIterable, Identifiable {
    case flameLord = "Flame Lords"
    case recruit = "Recruitable Characters"

    var id: Self { self }
}

enum BirdReaction: String, CaseIterable, Identifiable {
    case nod = "Nod"
    case spreadWings = "Spread your wings"
    case gazeIntently = "Gaze intently"
    case singBeautifulTune = "Sing a beautiful tune"
    case flapWings = "Flap your wings"
    case tiltHead = "Tilt your head"
    case beIntimidating = "Be intimidating"
    case doASomersault = "Do a somersault"
    case singSoftly = "Sing softly"
    case dance = "Dance"
    case clingToPerch = "Cling to your perch"
    case tremble = "Tremble"
    case preen = "Preen"
    case avertYourEyes = "Avert your eyes"
    case lookAtTheSky = "Look at the sky"
    case sitStill = "Sit still"
    case singWithVigor = "Sing with vigor"
    case singBoldly = "Sing boldly"
    case nodTimidly = "Nod timidly"

    var id: Self { self }

    var systemImage: String {
        switch self {
        case .nod, .nodTimidly: "arrow.up.right"
        case .spreadWings, .flapWings: "bird.fill"
        case .gazeIntently: "eye"
        case .singBeautifulTune, .singSoftly, .singWithVigor, .singBoldly: "music.note"
        case .tiltHead: "arrow.trianglehead.2.clockwise.rotate.90"
        case .beIntimidating: "bolt.fill"
        case .doASomersault: "figure.gymnastics"
        case .dance: "figure.dance"
        case .clingToPerch: "bird"
        case .tremble: "waveform.path.ecg"
        case .preen: "wand.and.stars"
        case .avertYourEyes: "eye.slash"
        case .lookAtTheSky: "cloud.sun"
        case .sitStill: "pause.circle"
        }
    }

    var tint: Color {
        switch self {
        case .beIntimidating, .tremble: .orange
        case .singBeautifulTune, .singSoftly, .singWithVigor, .singBoldly, .dance: .pink
        case .gazeIntently, .lookAtTheSky: .indigo
        case .spreadWings, .flapWings, .clingToPerch, .doASomersault: .teal
        case .nod, .nodTimidly, .tiltHead, .preen, .avertYourEyes, .sitStill: .blue
        }
    }
}

struct BirdTimeResponse: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    let reaction: BirdReaction?

    var isVerified: Bool { reaction != nil }
}

struct BirdTimeCharacter: Identifiable, Hashable {
    let id: String
    let name: String
    let category: CharacterCategory
    let responses: [BirdTimeResponse]

    var verifiedCount: Int { responses.filter(\.isVerified).count }
    var hasCompleteData: Bool { !responses.isEmpty && verifiedCount == responses.count }
    var initials: String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }
}
