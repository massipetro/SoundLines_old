//
//  IntroductionScreen.swift
//  Test1
//
//  Created by Fede on 04/07/19.
//  Copyright © 2019 Comelicode. All rights reserved.
//

import UIKit

class IntroductionScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);

        // Forces landscape orientation
        
        /*let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")*/
        
        // Reads label if VoiceOver is activated
        
        UIAccessibility.post(notification: .announcement, argument: "Level One: find the kitten, the cat and connect them following the horizontal line. Press play to continue.")

    }
    
    /*override var shouldAutorotate: Bool {
        return false
    }*/
}
