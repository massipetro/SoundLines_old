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
    
    // AudioKit setup and start
    
    var oscillator = AKFMOscillator()
    var oscillatorMid = AKFMOscillator()
    var oscillator2 = AKOscillator()
    var panner = AKPanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Creates AudioKit mixer and panner
        
        let mixer = AKMixer(oscillator, oscillatorMid,oscillator2)
        
        panner = AKPanner(mixer, pan: 0.0)
        
        AudioKit.output = panner
        
        // Audio is played with silent mode as well
        
        AKSettings.playbackWhileMuted = true
        
        try! AudioKit.start()
        
        // Hides the second label
        
        label2.isHidden = true
        
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var firstLevelShape: Shape!
    var firstElementFound: Bool = false
    var secondElementFound: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Game logic: find the first element, find the second element
        // When both are found create the line
        // If the second element has been reached, go to the next level
        
        // Adds tap gesture recognizer on the first element
        
        let tapped1 = UITapGestureRecognizer(target: self, action: #selector(firstElementSelected))
        label1.isUserInteractionEnabled = true
        label1.addGestureRecognizer(tapped1)
        
        // Adds tap gesture recognizer on the second element
        
        let tapped2 = UITapGestureRecognizer(target: self, action: #selector(secondElementSelected))
        label2.isUserInteractionEnabled = true
        label2.addGestureRecognizer(tapped2)
        
        // Tell the user to find the first element
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            UIAccessibility.post(notification: .announcement, argument: "Find the kitten")
        })

    }
    
    // Detects tapping on the first element
    // If tapped show second element and tell the user to find it
    
    @objc func firstElementSelected(sender: UITapGestureRecognizer) {
        print("firstElementSelected")
        
        // Tell the user the first element has been found
        
        UIAccessibility.post(notification: .announcement, argument: "You found the kitten! Find the cat")
        
        // Show the second element
        
        label2.isHidden = false
    }
    
    // Detects tapping on the second element
    
    @objc func secondElementSelected(sender: UITapGestureRecognizer) {
        print("secondElementSelected")
        
        // Tell the user the second element has been found
        
        UIAccessibility.post(notification: .announcement, argument: "You found the cat! Now go back to the kitten and follow the line to connect it to the cat")
        
        // Create the line
        
        createLine()
    }
    
    func createLine() -> Void {
        // Sets the line location and dimension:
        // it is located between the first element and the second element
        // it has the same heigth as the element
        
        let firstElementMaxX = label1.frame.maxX + 10
        let secondElementMinX = label2.frame.minX - 10
        
        let shapeWidth: CGFloat = secondElementMinX - firstElementMaxX
        let shapeHeight: CGFloat = label1.frame.height
        
        // Creates an accessibile rectangle shape
        
        firstLevelShape = Shape(frame: CGRect(x: firstElementMaxX,
                                              y: self.view.frame.size.height / 2 - shapeHeight / 2 - 25,
                                              width: shapeWidth,
                                              height: 75))
        
        firstLevelShape.isAccessibilityElement = true
        firstLevelShape.accessibilityHint = "shape"
        
        self.view.addSubview(firstLevelShape)
    }
    
    // Detects panning and prints OK if the user touches inside the shape
    
    @IBAction func panDetector(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        // Saves the point touched by the user
        
        let initialPoint = gestureRecognizer.location(in: view)
        
        guard gestureRecognizer.view != nil else {return}
        
        // Updates the position for the .began, .changed, and .ended states
        
        if gestureRecognizer.state != .cancelled {
            print(initialPoint)
            
            let firstLevelRect = firstLevelShape.getCGRect()
            
            // Distinguishes 3 cases based on the finger position:
            // 1. Inside the line but not in the center
            // 2. At the center of the line
            // 3. Outside the line
            
            // The finger is inside the line
            
            if (firstLevelRect.contains(initialPoint)) {
                print("OK: point is inside shape")
                
                // 1. Inside the line but not in the center
                
                oscillatorMid.stop()
                oscillator2.stop()
                oscillator.baseFrequency = Double(initialPoint.y)
                oscillator.amplitude = 1
                oscillator.start()
                
                // Creates a sub-shape which indicates the line center
                
                let y = self.view.frame.size.height / 2 - label1.frame.height / 2 - 25 + 37.5
                let minY = y - 5
                let maxY = y + 5
                
                let middleLineX = label1.frame.maxX + 10..<label2.frame.minX - 10
                let middleLineY = minY..<maxY
                
                // 2. At the center of the line
     
                if(middleLineX.contains(initialPoint.x) && middleLineY.contains(initialPoint.y)) {
                    print("Inside the middle line")
                    oscillator.stop()
                    oscillator2.stop()

                    panner.pan = normalize(num: Double(initialPoint.x))
                    
                    oscillatorMid.baseFrequency = 500
                    oscillatorMid.start()
                } else {
                    panner.pan = 0.0
                    
                }
                
            } else {
                
                // 3. Outside the line
                
                print("NO: point is outside shape")
                
                oscillatorMid.stop()
                oscillator.stop()
                oscillator2.amplitude = 0.5
                oscillator2.frequency = 200
                oscillator2.start()
            }
        }
    }
    
    // Normalizes double values for AudioKit panner
    
    func normalize(num: Double) -> Double {
        let min = Double(label1.frame.maxX + 10)
        let max = Double(label2.frame.minX - 10)
        return 2*((num - min)/(max - min))-1
    }
}
