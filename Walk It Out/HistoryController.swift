//
//  HistoryController.swift
//  Walk It Out
//
//  Created by James Barlian on 10/03/20.
//  Copyright © 2020 James Barlian. All rights reserved.
//

import UIKit
import CoreMotion

class HistoryController: UIViewController {

    @IBOutlet weak var stepHistory: UILabel!
    @IBOutlet weak var distanceHistory: UILabel!
    @IBOutlet weak var timeHistory: UILabel!
    @IBOutlet weak var weekStepReport: UILabel!
    @IBOutlet weak var weekDistanceReport: UILabel!
    
    var pedometer = CMPedometer()
    var numberOfSteps:Int = 0
    var distance:Double? = 0
    var (hours, minutes, seconds, fractions) = (0,0,0,0)

    var weekSteps: [Int] = [850,767,900,876,753,698]
    var weekDistance: [Int] = [3412,2592,3012,2802,2423,3812]

    var totalWeekSteps = 0
    var totalWeekDistance = 0
    
    func addWeekSteps(){
        weekSteps.append(numberOfSteps)
        for i in weekSteps{
            totalWeekSteps += i
        }
        
    }
    
    func addWeekDistance(){
        weekDistance.append(Int(distance!))
        for i in weekDistance{
            totalWeekDistance += i
        }
    }
    
    func previousExercise(){
        self.stepHistory.text = "Number of Steps: \(numberOfSteps)"

        self.distanceHistory.text = "Total Distance: \(Int((distance ?? 0))) meters"

        self.timeHistory.text = "Total Time: \(hours):\(minutes):\(seconds)"
    }
    
    func weeklyExercise(){
        addWeekSteps()
        addWeekDistance()
        weekStepReport.text  = "Steps This Week: \(totalWeekSteps) Steps"
        weekDistanceReport.text = "Total Distance: \( totalWeekDistance) meters"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previousExercise()
        weeklyExercise()
        
        
    }
}
