//
//  OpenScreen.swift
//  Test1
//
//  Created by Fede on 04/07/19.
//  Copyright © 2019 Comelicode. All rights reserved.
//

import UIKit

class OpenScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Forces landscape orientation

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Reads label if VoiceOver is activated
        
        UIAccessibility.post(notification: .announcement, argument: "SoundLines: help a kitten play with its cat friend!  Press play to continue.")
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}
