//
//  ViewController+SliderPositionDelegate.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//
import UIKit

extension ViewController: SliderPositionDelegate {
    func sliderChangedPositionTo(seconds: Int) {
                if seconds == 0 {
        
                    UIView.animate(withDuration: 0.2) {
                        self.startButtonView.alpha = 0
                    }
        
                    timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
                    timeLabel.text = selectingTimeText
                }
        
                else {
        
                    startButtonView.isHidden = false
        
                    UIView.animate(withDuration: 0.2) {
                        self.startButtonView.alpha = 1
                    }
        
                    timeLabel.font = UIFont.boldSystemFont(ofSize: 45)
                    timeLabel.text = secondsToHoursMinutesSeconds(seconds: seconds)
                }
    }
    
    
    func sliderChangedToDivition(divition: Int) {
        
        landmarkImage.image = UIImage(named: landmarks[divition])
        
    }
}


