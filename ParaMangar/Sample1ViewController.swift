//
//  Sample1ViewController.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/03/10.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit
import ParaMangarLib

class Sample1ViewController: UIViewController {
    
    @IBOutlet var targetView: UIView!
    @IBOutlet var frameIntervalLabel: UILabel!
    @IBOutlet var frameIntervalStepper: UIStepper!
    @IBOutlet var render1SecButton: UIButton!
    
    var animator: ParaMangar?
    
    @IBAction func onFrameIntervalStepper(sender: UIStepper) {
        self.frameIntervalLabel.text = "\(Int(self.frameIntervalStepper.value))"
    }
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        let duration = 1.0
        self.animator = ParaMangar.renderViewForDuration(self.targetView, duration: duration, frameInterval: Int(self.frameIntervalStepper.value)).toFile("Sample1", completion: {path in
            self.animator = nil
            self.render1SecButton.setTitle("Completed!", forState: UIControlState.Normal)
            println("Completed: \(path)")
            return
        })
    }
    
}
