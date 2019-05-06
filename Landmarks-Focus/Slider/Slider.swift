//
//  Slider.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 5/4/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit


struct Slider {
    
    
    init(containter: UIView) {
        self.container = containter
        
        sliderDivitionsPositions = [CGFloat]()
        sliderSubdivitionsPositions = [CGFloat]()
        
        userIsMovingSlider = false
    }
    
    var container: UIView
    
    var sliderDivitionsPositions: [CGFloat]
    var sliderSubdivitionsPositions: [CGFloat]
    
    var userIsMovingSlider: Bool
    
    
    lazy var arrow: UIImageView = {
        let view = UIImageView(image: UIImage(named: "slider-arrow")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var timePosition: CGFloat = 0 {
        didSet {
            
            let actualDivition = getActualDivition(forTimePosition: timePosition)
            delegate?.sliderChangedToDivition(divition: actualDivition)
            
            if timePosition != oldValue {
                if timePosition == container.frame.height || timePosition == 0{
                    sendHapticFeedback(intensity: .strong)
                }
                else if sliderDivitionsPositions.contains(timePosition){
                    sendHapticFeedback(intensity: .medium)
                }
                else if sliderSubdivitionsPositions.contains(timePosition){
                    sendHapticFeedback(intensity: .weak)
                }
            }
        }
    }
    
    var actualPositionInSeconds: Int = 0 {
        willSet{
            delegate?.sliderChangedPositionTo(seconds: newValue)
        }
    }
    
    var delegate: SliderPositionDelegate?
    
    
    mutating func setup(){
        container.addSubview(arrow)
        arrow.image = arrow.image?.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = UIColor.Slider.light
        arrow.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: arrow.frame.width / 4).isActive = true
        arrow.centerYAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        let linePath = UIBezierPath()
        let lineWidth = CGFloat(5)
        
        let sliderCenterXPosition = container.frame.width / 2 - lineWidth / 2
        
        linePath.move(to: CGPoint(x: sliderCenterXPosition, y: 0))
        linePath.addLine(to: CGPoint(x: sliderCenterXPosition, y: container.frame.height))
        
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.Slider.light.cgColor
        lineLayer.lineWidth = lineWidth
        
        container.layer.addSublayer(lineLayer)
        
//        timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        timeLabel.text = selectingTimeText
        
        
        let circleRadius = CGFloat(5)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: sliderCenterXPosition, y: 0), radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let topCircleLayer = CAShapeLayer()
        
        topCircleLayer.path = circlePath.cgPath
        topCircleLayer.strokeColor = UIColor.Slider.light.cgColor
        topCircleLayer.lineWidth = 3
        topCircleLayer.fillColor = UIColor.Slider.light.cgColor
        
        container.layer.addSublayer(topCircleLayer)
        
        let bottomCirclePath = UIBezierPath(arcCenter: CGPoint(x: sliderCenterXPosition, y: container.frame.height), radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let bottomCircleLayer = CAShapeLayer()
        
        bottomCircleLayer.path = bottomCirclePath.cgPath
        bottomCircleLayer.strokeColor = UIColor.Slider.light.cgColor
        bottomCircleLayer.lineWidth = 3
        bottomCircleLayer.fillColor = UIColor.Slider.light.cgColor
        
        container.layer.addSublayer(bottomCircleLayer)
        
        
        let numberOfDivitionsInSlider = 6
        let divitionHeight = container.frame.height / CGFloat(numberOfDivitionsInSlider)
        let divitionLenght = CGFloat(10)
        
        let numberOfSubdivitionsInSliderDivition = 2
        let subdivitionHeight = divitionHeight / CGFloat(numberOfSubdivitionsInSliderDivition)
        let subdivitionLenght = CGFloat(5)
        let subdivitionLineWidth = CGFloat(2.5)
        
        
        for divition in 1..<numberOfDivitionsInSlider {
            let sliderDivitionPath = UIBezierPath()
            let divitionHeightPosition = CGFloat(divition) * divitionHeight
            
            sliderDivitionsPositions.append(divitionHeightPosition)
            
            sliderDivitionPath.move(to: CGPoint(x: sliderCenterXPosition - divitionLenght, y: divitionHeightPosition))
            sliderDivitionPath.addLine(to: CGPoint(x: sliderCenterXPosition + divitionLenght, y: divitionHeightPosition))
            
            let divitionLayer = CAShapeLayer()
            divitionLayer.path = sliderDivitionPath.cgPath
            divitionLayer.strokeColor = UIColor.Slider.light.cgColor
            divitionLayer.lineWidth = lineWidth
            
            container.layer.addSublayer(divitionLayer)
            
        }
        
        for divition in 0..<numberOfDivitionsInSlider {
            let actualDivitionPosition = container.frame.height - (CGFloat(divition) * divitionHeight)
            
            for subdivition in 1...numberOfSubdivitionsInSliderDivition {
                let actualSubdivitionPosition = actualDivitionPosition - (CGFloat(subdivition) * subdivitionHeight)
                sliderSubdivitionsPositions.append(actualSubdivitionPosition)
                
                let subdivitionPath = UIBezierPath()
                subdivitionPath.move(to: CGPoint(x: sliderCenterXPosition - subdivitionLenght, y: actualSubdivitionPosition))
                subdivitionPath.addLine(to: CGPoint(x: sliderCenterXPosition + subdivitionLenght, y: actualSubdivitionPosition))
                
                let subdivitionLayer = CAShapeLayer()
                subdivitionLayer.path = subdivitionPath.cgPath
                subdivitionLayer.strokeColor = UIColor.Slider.light.cgColor
                subdivitionLayer.lineWidth = subdivitionLineWidth
                
                container.layer.addSublayer(subdivitionLayer)
                
            }
        }
        
    }
    
    func getActualDivition(forTimePosition position: CGFloat) -> Int{
        
        var index: Int = 0
        
        while position > sliderDivitionsPositions[index] {
            index += 1
            if index == sliderDivitionsPositions.count {
                return index
            }
        }
        
        return index
    }
    
    mutating func moveArrowTo(position: CGPoint){

        let centerXPosition = container.frame.width / 2 + arrow.frame.width / 4
        
        let centerYPosition: CGFloat

        switch position.y {
        case ..<0:
            centerYPosition = 0
        case ..<container.frame.height:
            centerYPosition = position.y
        default:
            centerYPosition = container.frame.height
        }
        calculateTimeForArrow(position: centerYPosition)
        arrow.center = CGPoint(x: centerXPosition, y: centerYPosition)
    }
    
    
    mutating func calculateTimeForArrow(position: CGFloat){
        let maximumPossibleTimeInSeconds:Int = 10_800
        let variation = CGFloat(3)

        var selectedPosition: CGFloat = position

        let divitionsArray = (sliderDivitionsPositions + sliderSubdivitionsPositions).sorted()

        var sliderDivitionsPositionsSorted = divitionsArray

        sliderDivitionsPositionsSorted.insert(0, at: 0)
        sliderDivitionsPositionsSorted.insert(container.frame.height, at: sliderDivitionsPositionsSorted.count - 1)

        var closestDivition: CGFloat = sliderDivitionsPositionsSorted[0]

        for divition in sliderDivitionsPositionsSorted {
            if abs(position - divition) < abs(position - closestDivition){
                closestDivition = divition
            }
        }

        if closestDivition - variation ... closestDivition + variation ~= position {
            selectedPosition = closestDivition
        }

        timePosition = abs(selectedPosition - container.frame.height)


        actualPositionInSeconds = Int(CGFloat(timePosition) * CGFloat(maximumPossibleTimeInSeconds) / container.frame.height)
        

    }
    
    
    
    
    
}
