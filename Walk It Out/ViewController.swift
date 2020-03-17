//
//  ViewController.swift
//  Walk It Out
//
//  Created by James Barlian on 03/03/20.
//  Copyright © 2020 James Barlian. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    // Progress View
    @IBOutlet weak var CircularProgress: CircularProgressView!
    
    var pedometer = CMPedometer()
    
    // color of the start/stop button
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
    
    // values for the pedometer
    var numberOfSteps:Int? = 0
    var distance:Double? = 0
    var stepGoal:Int? = 50

    // timers
    var timer = Timer()
    var (hours, minutes, seconds, fractions) = (0,0,0,0)
    
    // Progress View
    let shapeLayer = CAShapeLayer()
    let progress = Progress(totalUnitCount: 10)
    
    // Current date
    let currentDate = Date()
    
    // Saving Data
    let defaults = UserDefaults.standard
    
    
    @IBAction func startStopButton(_ sender: UIButton) {
            if sender.titleLabel?.text == "Start"{
                
                //Start the timer
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.keepTimer), userInfo: nil, repeats: true)
                
                fractions += 1
                if fractions > 99 {
                    seconds += 1
                    fractions = 0
                }
                if seconds == 60 {
                    minutes += 1
                    seconds = 0
                }
                if minutes == 60 {
                    hours += 1
                    minutes = 0
                }
                
                let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
                let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
                let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
                
                timerLabel.text = "\(hoursString):\(minutesString):\(secondString)"
                // fractionsLabel.text = ".\(fractions)"
                
                //Start the pedometer
                pedometer = CMPedometer()
                
                pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                    DispatchQueue.main.async {
                        
                        // Display number of steps according to pedometer
                        if let pedData = pedometerData{
                            self.numberOfSteps = Int(pedData.numberOfSteps)
                            self.stepsLabel.text = "\(pedData.numberOfSteps)"
                          
                        // Display Distance according to steps
                        if let distance = pedData.distance{
                                self.distance = Double(distance)
                            self.distanceLabel.text = "\(Float((distance)))\nmeters"
                            }
                        }
                         else {
                            self.numberOfSteps = nil
                        }
                    }
                    
                })
                
                //Toggle the UI to on state
                statusTitle.text = "Pedometer On"
                sender.setTitle("Stop", for: .normal)
                sender.backgroundColor = stopColor
                
            } else {
                
                //Stop the timer
                timer.invalidate()
                
                //Stop the pedometer
                pedometer.stopUpdates()
                
                // Track Progress
            
                CircularProgress.progressAnimation(duration: 5, value: Float(numberOfSteps ?? 0) / Float(stepGoal ?? 0))
                
                //Toggle the UI to off state
                statusTitle.text = "Pedometer Off"
                sender.backgroundColor = startColor
                sender.setTitle("Start", for: .normal)
            }
        }
         
        // Resets everything before viewing
        func reset(){
            statusTitle.text = "Pedometer Off"
            distanceLabel.text = "0\nKm"
            buttonLabel.titleLabel?.text = "Start"
            goalLabel.text = "50\nStep Goal"
            buttonLabel.backgroundColor? = startColor
            stepsLabel.text = "0"
        }
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            reset()
            
//            let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 200.0, height: 100.0))
//                cp.trackColor = UIColor.white
//                cp.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 165.0/255.0, alpha: 1.0)
//                cp.tag = 101
//                self.view.addSubview(cp)
//                cp.center = self.view.center
//
//                self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
            
            CircularProgress.createCircularPath()
                
//            CircularProgress.trackColor = UIColor.clear
//            CircularProgress.progressColor = UIColor(red: 234.0/255.0, green: 143.0/255.0, blue: 68.0/255.0, alpha: 1.0)

        }
     
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
     
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)

    }
    
//    @objc func animateProgress() {
//        let cP = self.view.viewWithTag(101) as! CircularProgressView
//        cP.setProgressWithAnimation(duration: 1.0, value: 0.7)
//
//    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    // Timer
    @objc func keepTimer(){
        fractions += 1
        if fractions > 99 {
            seconds += 1
            fractions = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        timerLabel.text = "\(hoursString):\(minutesString):\(secondString)"
        // fractionsLabel.text = ".\(fractions)"
    }
    
    // Minus increment Step Goal
    @IBAction func minusGoal(_ sender: UIButton) {
        if stepGoal! >= 100{
            stepGoal! -= 50
            goalLabel.text = "\(Int(stepGoal!))\nStep Goal"
        }
    }
    // Plus increment Step Goal
    @IBAction func plusGoal(_ sender: UIButton) {
        stepGoal! += 50
        goalLabel.text = "\(Int(stepGoal!))\nStep Goal"
    }

    // Saving data
//    func saveSteps(){
//        defaults.set(numberOfSteps, forKey:"Saved Steps")
//    }
//
//    func checkForSteps(){
//        let savedSteps = defaults.value(forKey: "Saved Steps") as? String ?? ""
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistory" {
            
            // Send Data
            // destination segue
            if let destination = segue.destination as? HistoryController{
                destination.numberOfSteps = self.numberOfSteps ?? 0
                destination.hours = self.hours
                destination.minutes = self.minutes
                destination.seconds = self.seconds
                destination.distance = self.distance ?? 0
            }
        }
    }
}
