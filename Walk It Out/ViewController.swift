//
//  ViewController.swift
//  Walk It Out
//
//  Created by James Barlian on 03/03/20.
//  Copyright © 2020 James Barlian. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var walkIcon: UIImageView!
    @IBOutlet weak var walkIcon2: UIImageView!
    @IBOutlet weak var stepperLabel: UIStepper!

    
    var pedometer = CMPedometer()
    
    // color of the start/stop button
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
//    let textField = UITextField(frame: CGRect(x: 82.0, y:668.0, width: 250.0, height: 40.0))
    
    // values for the pedometer data
    var numberOfSteps:Int? = nil
    var distance:Double? = nil
    var calories:Int? = nil
    var bodyWeight:Int = 70
    var velocity:Float = 1.4
    var height:Double = 1.78
    
    @IBAction func startStopButton(_ sender: UIButton) {
            if sender.titleLabel?.text == "Start"{
               
                walkIcon.image = #imageLiteral(resourceName: "human-icon-vector-png-3")
                walkIcon2.image = #imageLiteral(resourceName: "human-icon-vector-png-3")
                
                //Start the pedometer
                pedometer = CMPedometer()
                
                pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                    DispatchQueue.main.async {
                        
                        if let pedData = pedometerData{
                            // self.numberOfSteps = Int(pedData.numberOfSteps)
                            self.stepsLabel.text = "Steps\n\(pedData.numberOfSteps)"
                            
                        if let distance = pedData.distance{
                               // self.distance = Double(distance)
                                self.distanceLabel.text = "Distance\n\(Float(distance))\nmeters"
                            }
                        } else {
                            self.numberOfSteps = nil
                        }
                    }
                    // Show alert if Goal is reached
//                    if pedometerData?.numberOfSteps > 25{
//                        self.showAlert()
//                    }
                    
                })
                //Toggle the UI to on state
                statusTitle.text = "Pedometer On"
                sender.setTitle("Stop", for: .normal)
                sender.backgroundColor = stopColor
            } else {
                walkIcon.image = #imageLiteral(resourceName: "blank")
                walkIcon2.image = #imageLiteral(resourceName: "blank")
                
                //Stop the pedometer
                pedometer.stopUpdates()
                
                //Toggle the UI to off state
                statusTitle.text = "Pedometer Off"
                sender.backgroundColor = startColor
                sender.setTitle("Start", for: .normal)
            }
        }
    
        func miles(meters:Double)-> Double{
            let mile = 0.000621371192
            return meters * mile
        }
    
        // display the updated data
        func displayPedometerData(){

            //Number of steps
            if let numberOfSteps = self.numberOfSteps{
                stepsLabel.text = String(format:"Steps: %i",numberOfSteps)
            }
             
            //distance
            if let distance = self.distance{
                distanceLabel.text = String(format:"Distance: %02.02f meters,\n %02.02f mi",distance,miles(meters: distance))
            } else {
                distanceLabel.text = "Distance: N/A"
            }
        }
    
    // To set step goal increments by 50
    @IBAction func goalSetter(_ sender: UIStepper) {
        goalLabel.text = "Step Goal: \(Int(sender.value * 50))"
    }
         
        // Resets everything before viewing
        func reset(){
            statusTitle.text = "Pedometer Off"
            distanceLabel.text = "Distance\n0"
            buttonLabel.titleLabel?.text = "Start"
            goalLabel.text = "Step Goal: 0"
            buttonLabel.backgroundColor? = startColor
            stepsLabel.text = "Steps\n0"
            walkIcon.image = #imageLiteral(resourceName: "blank")
            walkIcon2.image = #imageLiteral(resourceName: "blank")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            reset()
            
            stepsLabel.layer.cornerRadius = stepsLabel.frame.size.width / 2
            distanceLabel.layer.cornerRadius = distanceLabel.frame.size.width / 2
            goalLabel.layer.cornerRadius = 15
            buttonLabel.layer.cornerRadius = buttonLabel.frame.size.width / 2
            stepperLabel.layer.cornerRadius = 15
            
            // Do any additional setup after loading the view.
        }
     
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
     
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
//        textField.delegate = self
//        textField.returnKeyType = .done
//
//
//        textField.center = self.view.center
//        textField.backgroundColor = UIColor.white
//        textField.keyboardType = UIKeyboardType.numberPad
//
//
//        self.view.addSubview(textField)
//
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        textField.resignFirstResponder()
//        return true
//    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Message", message: "You reached your step goal", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
     
}

