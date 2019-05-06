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
    
    var landmarks = ["pyramid", "china", "sided_tower", "statue_of_liberty", "eiffel_tower", "big_ben"]
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButtonView: UIView!
    
    @IBOutlet weak var landmarkView: UIView!
    @IBOutlet weak var landmarkImage: UIImageView!
    
    
    let selectingTimeText = "Selecciona cuanto tiempo deseas concentrarte..."
    
    var backgroundGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    var slider: Slider!
    
    override func viewDidLoad() {
        slider = Slider(containter: sliderView)
        slider.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        startButtonView.isHidden = true
        startButtonView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        slider.setup()
        setUpTimeView()
        setupBackground()
    }
    
    func setUpTimeView(){
        timeLabel.textColor = UIColor.Text.light
    }
    
    
    

}

