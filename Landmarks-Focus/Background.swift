//
//  Background.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//
import UIKit

extension ViewController {
    
    func setBackgroundGradientColorsTo(_ colors: [CGColor]){
        backgroundGradientLayer.colors = colors
    }
    
    func setupBackground(){
        setBackgroundGradientColorsTo(backgroundColors[0].map({$0.cgColor}))
        
        backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundGradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
}
