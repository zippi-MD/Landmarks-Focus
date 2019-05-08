//
//  Background.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//
import UIKit

struct Background {

    fileprivate var backgroundLayer: CAGradientLayer = {
       return CAGradientLayer()
    }()

    func setupBackgroundForView(_ view: UIView, colors: [CGColor]){
        backgroundLayer.colors = colors

        backgroundLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundLayer.frame = view.bounds

        view.layer.insertSublayer(backgroundLayer, at: 0)
    }

}
