//
//  Level1.swift
//  Test1
//
//  Created by simona1971 on 25/06/19.
//  Copyright © 2019 Comelicode. All rights reserved.
//
// Level1: creates two elements, then a line between them, and detects if
// the user pans inside the line

import UIKit
import AudioKit

class Level1: UIViewController {
    
    var oscillator = AKOscillator()
    var oscillator2 = AKOscillator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let oscillator = AKOscillator()
        oscillator.amplitude = 0.1
        AudioKit.output = oscillator
        
        try! AudioKit.start()
        oscillator.start()*/
        
        AudioKit.output = AKMixer(oscillator, oscillator2)
        try! AudioKit.start()
        
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var firstLevelShape: Shape!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sets the line location and dimension:
        // it is located between the first element and the second element
        // it has the same heigth as the element
        
        let firstElementMaxX = label1.frame.maxX
        let secondElementMinX = label2.frame.minX - 15
        
        let shapeWidth: CGFloat = secondElementMinX - firstElementMaxX
        let shapeHeight: CGFloat = label1.frame.height
        
        // Creates an accessibile rectangle shape
        
        firstLevelShape = Shape(frame: CGRect(x: firstElementMaxX + 10,
                                              y: self.view.frame.size.height / 2 - shapeHeight / 2,
                                              width: shapeWidth,
                                              height: shapeHeight))
        
        firstLevelShape.isAccessibilityElement = true
        firstLevelShape.accessibilityHint = "shape"
        
        self.view.addSubview(firstLevelShape)
    }
    
    // Detects panning and prints OK if the user touches inside the shape
    
    @IBAction func panDetector(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        // Saves the point touched by the user
        
        let initialPoint = gestureRecognizer.location(in: view)
        
        guard gestureRecognizer.view != nil else {return}
        
        // Update the position for the .began, .changed, and .ended states
        
        if gestureRecognizer.state != .cancelled {
            print(initialPoint)
            
            let firstLevelRect = firstLevelShape.getCGRect()
            
            // Prints OK if the point is inside the shape, NO otherwise
            
            if (firstLevelRect.contains(initialPoint)) {
                print("OK: point is inside shape")
                if oscillator.isPlaying {
                    oscillator.stop()
                    
                } else {
                    oscillator.amplitude = random(0.5, 1)
                    oscillator.frequency = random(220, 880)
                    oscillator.start()
                }
            } else {
                print("NO: point is outside shape")
                oscillator.stop()
            }
        }
    }
}
