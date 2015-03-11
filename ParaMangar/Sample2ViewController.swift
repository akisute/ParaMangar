//
//  Sample2ViewController.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/03/11.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit
import ParaMangarLib

class Sample2ViewController: UIViewController {
    
    @IBOutlet var targetView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var render1SecButton: UIButton!
    
    var animator: ParaMangar?
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        let duration = 1.0
        self.animator = ParaMangar.renderViewForDuration(self.targetView, duration: duration).toImage(duration, completion: { image in
            self.animator = nil
            self.render1SecButton.setTitle("Completed!", forState: UIControlState.Normal)
            self.imageView.image = image
        })
    }
    
}
