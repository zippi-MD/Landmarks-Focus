//
//  HapticFeedback.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

enum feedbackResponseStreght {
    case weak, medium, strong
}

func sendHapticFeedback(intensity: feedbackResponseStreght){
    switch intensity {
    case .weak:
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    case .medium:
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    case .strong:
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
