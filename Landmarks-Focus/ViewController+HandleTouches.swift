//
//  ViewController+HandleTouches.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: view)
            
            if appState == .selectingTime && slider.arrow.bounds.contains(slider.arrow.convert(location, from: view)){
                slider.userIsMovingSlider = true
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, appState == .selectingTime, slider.userIsMovingSlider {
            let location = touch.location(in: sliderView)
            slider.moveArrowTo(position: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appState == .selectingTime {
            slider.userIsMovingSlider = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appState == .selectingTime {
            slider.userIsMovingSlider = false
        }
    }
    
}
