//
//  Sample3ViewController.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/03/11.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit
import ParaMangarLib

class Sample3ViewController: UIViewController {
    
    @IBOutlet var targetView: UIView!
    @IBOutlet var animatingView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var render1SecButton: UIButton!
    
    var animator: ParaMangar?
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        let duration = 1.0
        self.animator = ParaMangar.renderViewForDuration(self.targetView, duration: duration, block: {
            UIView.animateWithDuration(duration/2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.animatingView.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }, completion: nil)
            UIView.animateWithDuration(duration/2, delay: duration/2, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.animatingView.transform = CGAffineTransformIdentity
                }, completion: nil)
        }).toImage(duration, completion: { image in
            self.animator = nil
            self.render1SecButton.setTitle("Completed!", forState: UIControlState.Normal)
            self.imageView.image = image
        })
    }
    
}
