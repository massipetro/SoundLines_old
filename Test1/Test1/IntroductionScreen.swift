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

        // Forces landscape orientation
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
