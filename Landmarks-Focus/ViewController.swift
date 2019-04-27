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

class ViewController: UIViewController {

    var appState: appState = .selectingTime
    
    @IBOutlet weak var sliderView: UIView!
    
    var userIsMovingSlider: Bool = false
    
    
    lazy var sliderArrow: UIImageView = {
        let view = UIImageView(image: UIImage(named: "slider-arrow")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        linePath.addLine(to: CGPoint(x: sliderView.frame.width / 2 - lineWidth / 2, y: sliderView.frame.height))
        
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.lineWidth = lineWidth
        
        sliderView.layer.addSublayer(lineLayer)
        
        
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
        
        
        let numberOfDivitionsInSlider = 5
        let divitionHeight = sliderView.frame.height / CGFloat(numberOfDivitionsInSlider)
        let divitionLenght = CGFloat(10)
        
        for divition in 1..<numberOfDivitionsInSlider {
            let sliderDivitionPath = UIBezierPath()
            let divitionHeightPosition = CGFloat(divition) * divitionHeight
            
            sliderDivitionPath.move(to: CGPoint(x: sliderCenterXPosition - divitionLenght, y: divitionHeightPosition))
            sliderDivitionPath.addLine(to: CGPoint(x: sliderCenterXPosition + divitionLenght, y: divitionHeightPosition))
            
            let divitionLayer = CAShapeLayer()
            divitionLayer.path = sliderDivitionPath.cgPath
            divitionLayer.strokeColor = UIColor.black.cgColor
            divitionLayer.lineWidth = lineWidth
            
            sliderView.layer.addSublayer(divitionLayer)
            
            
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
        
        
        sliderArrow.center = CGPoint(x: centerXPosition, y: centerYPosition)
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

