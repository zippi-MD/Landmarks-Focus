//
//  ViewController.swift
//  Landmarks-Focus
//
//  Created by Alejandro Mendoza on 4/25/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

enum appState {
    case selectingTime, countdown
}

enum feedbackResponseStreght {
    case light, strong
}

class ViewController: UIViewController {

    var appState: appState = .selectingTime
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButtonView: UIView!
    
    let selectingTimeText = "Selecciona cuanto tiempo deseas concentrarte..."
    
    var userIsMovingSlider: Bool = false
    
    var sliderDivitionsPositions = [CGFloat]()
    var sliderSubdivitionsPositions = [CGFloat]()
    
    var lastHapticFeedbackSendedForValue: CGFloat = 0
    
    
    lazy var sliderArrow: UIImageView = {
        let view = UIImageView(image: UIImage(named: "slider-arrow")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupSlider()
    }
    
    func setupSlider(){
        sliderView.addSubview(sliderArrow)
        sliderArrow.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor, constant: sliderArrow.frame.width / 4).isActive = true
        sliderArrow.centerYAnchor.constraint(equalTo: sliderView.bottomAnchor).isActive = true
        
        let linePath = UIBezierPath()
        let lineWidth = CGFloat(5)
        
        let sliderCenterXPosition = sliderView.frame.width / 2 - lineWidth / 2
        
        linePath.move(to: CGPoint(x: sliderCenterXPosition, y: 0))
        linePath.addLine(to: CGPoint(x: sliderCenterXPosition, y: sliderView.frame.height))
        
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.lineWidth = lineWidth
        
        sliderView.layer.addSublayer(lineLayer)
        
        timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        timeLabel.text = selectingTimeText
        
        
        let circleRadius = CGFloat(5)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: sliderCenterXPosition, y: 0), radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let topCircleLayer = CAShapeLayer()
        
        topCircleLayer.path = circlePath.cgPath
        topCircleLayer.strokeColor = UIColor.black.cgColor
        topCircleLayer.lineWidth = 3
        topCircleLayer.fillColor = UIColor.black.cgColor
        
        sliderView.layer.addSublayer(topCircleLayer)
        
        let bottomCirclePath = UIBezierPath(arcCenter: CGPoint(x: sliderCenterXPosition, y: sliderView.frame.height), radius: circleRadius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let bottomCircleLayer = CAShapeLayer()
        
        bottomCircleLayer.path = bottomCirclePath.cgPath
        bottomCircleLayer.strokeColor = UIColor.black.cgColor
        bottomCircleLayer.lineWidth = 3
        bottomCircleLayer.fillColor = UIColor.black.cgColor
        
        sliderView.layer.addSublayer(bottomCircleLayer)
        
        
        let numberOfDivitionsInSlider = 6
        let divitionHeight = sliderView.frame.height / CGFloat(numberOfDivitionsInSlider)
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
            divitionLayer.strokeColor = UIColor.black.cgColor
            divitionLayer.lineWidth = lineWidth
            
            sliderView.layer.addSublayer(divitionLayer)
            
        }
        
        for divition in 0..<numberOfDivitionsInSlider {
            let actualDivitionPosition = sliderView.frame.height - (CGFloat(divition) * divitionHeight)
            
            for subdivition in 1...numberOfSubdivitionsInSliderDivition {
                let actualSubdivitionPosition = actualDivitionPosition - (CGFloat(subdivition) * subdivitionHeight)
                sliderSubdivitionsPositions.append(actualSubdivitionPosition)
                
                let subdivitionPath = UIBezierPath()
                subdivitionPath.move(to: CGPoint(x: sliderCenterXPosition - subdivitionLenght, y: actualSubdivitionPosition))
                subdivitionPath.addLine(to: CGPoint(x: sliderCenterXPosition + subdivitionLenght, y: actualSubdivitionPosition))
                
                let subdivitionLayer = CAShapeLayer()
                subdivitionLayer.path = subdivitionPath.cgPath
                subdivitionLayer.strokeColor = UIColor.black.cgColor
                subdivitionLayer.lineWidth = subdivitionLineWidth
                
                sliderView.layer.addSublayer(subdivitionLayer)
                
            }
        }
        
    }
    
    func moveSliderArrowTo(position: CGPoint){
        
        let sliderCenterCoordinates = sliderView.convert(sliderView.center, from: view)
        
        let centerXPosition = sliderCenterCoordinates.x + sliderArrow.frame.width / 4
        let centerYPosition: CGFloat
        
        switch position.y {
        case ..<0:
            centerYPosition = 0
        case ..<sliderView.frame.height:
            centerYPosition = position.y
        default:
            centerYPosition = sliderView.frame.height
        }
        
        calculateTimeForSliderArrow(position: centerYPosition)
        sliderArrow.center = CGPoint(x: centerXPosition, y: centerYPosition)
    }
    
    func calculateTimeForSliderArrow(position: CGFloat){
        let maximumPossibleTimeInSeconds:Int = 10_800
        let variation = CGFloat(3)
        
        var timePosition: CGFloat = position
        
        let divitionsArray = (sliderDivitionsPositions + sliderSubdivitionsPositions).sorted()
        
        var sliderDivitionsPositionsSorted = divitionsArray
        
        sliderDivitionsPositionsSorted.insert(0, at: 0)
        sliderDivitionsPositionsSorted.insert(sliderView.frame.height, at: sliderDivitionsPositionsSorted.count - 1)
        
        var closestDivition: CGFloat = sliderDivitionsPositionsSorted[0]
        
        for divition in sliderDivitionsPositionsSorted {
            if abs(position - divition) < abs(position - closestDivition){
                closestDivition = divition
            }
        }
        
        if closestDivition - variation ... closestDivition + variation ~= position {
            timePosition = closestDivition
            if lastHapticFeedbackSendedForValue != closestDivition {
                sliderDivitionsPositions.contains(closestDivition) ? sendHapticFeedback(intensity: .strong) : sendHapticFeedback(intensity: .light)
                
                lastHapticFeedbackSendedForValue = closestDivition
            }
            
        }
        
        timePosition = abs(timePosition - sliderView.frame.height)

        let timeForPositionInSeconds = Int(CGFloat(timePosition) * CGFloat(maximumPossibleTimeInSeconds) / sliderView.frame.height)
        
        if timeForPositionInSeconds == 0 {
            timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
            timeLabel.text = selectingTimeText
        }
        else {
            timeLabel.font = UIFont.boldSystemFont(ofSize: 45)
            timeLabel.text = secondsToHoursMinutesSeconds(seconds: timeForPositionInSeconds)
        }
        

        
        
        
    }
    
    func sendHapticFeedback(intensity: feedbackResponseStreght){
        switch intensity {
        case .light:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        case .strong:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        return  formatter.string(from: TimeInterval(seconds))!

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: view)
            
            if appState == .selectingTime && sliderArrow.bounds.contains(sliderArrow.convert(location, from: view)){
                userIsMovingSlider = true
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, appState == .selectingTime, userIsMovingSlider {
            let location = touch.location(in: sliderView)
            moveSliderArrowTo(position: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appState == .selectingTime {
            userIsMovingSlider = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appState == .selectingTime {
            userIsMovingSlider = false
        }
    }


}

