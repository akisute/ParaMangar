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
    @IBOutlet var render1SecButton: UIButton!
    
    var animator: ParaMangar?
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        self.animator = ParaMangar.renderAnimationOfView(self.targetView, duration: 1.0, delay: 0, options: UIViewAnimationOptions.allZeros, animations: {
            return
        }).toFile("Sample1", completion: {path in
            self.animator = nil
            self.render1SecButton.setTitle("Completed!", forState: UIControlState.Normal)
            println("Completed: \(path)")
            return
        })
    }
    
}
