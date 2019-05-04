//
//  Time.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import Foundation

func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    
    return  formatter.string(from: TimeInterval(seconds))!
    
}
