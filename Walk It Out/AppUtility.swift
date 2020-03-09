//
//  AppUtility.swift
//  Walk It Out
//
//  Created by James Barlian on 06/03/20.
//  Copyright © 2020 James Barlian. All rights reserved.
//

import Foundation
import UIKit

struct AppUtility {

    // To lock the screen to be portrait
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

}
