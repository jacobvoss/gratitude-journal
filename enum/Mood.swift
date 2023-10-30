//
//  Mood.swift
//  GratitudeJournal
//
//  Created by Jacob Voss on 17.03.23.
//

import Foundation

enum Mood: Int16, CaseIterable {
    case happy = 0
    case neutral = 1
    case sad = 2

    var emoji: String {
        switch self {
        case .happy:
            return "😊"
        case .neutral:
            return "😐"
        case .sad:
            return "😔"
        }
    }
}
