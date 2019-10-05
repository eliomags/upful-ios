//
//  Vibration.swift
//  Upful
//
//  Created by Yanik Simpson on 10/4/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import UIKit

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
}

extension Vibration {
    func vibrate() {
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
