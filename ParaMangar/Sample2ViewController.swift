//
//  Sample2ViewController.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/03/11.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import Foundation
import ParaMangarLib

class Sample2ViewController: UIViewController {
    
    @IBOutlet var targetView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var render1SecButton: UIButton!
    
    var animator: ParaMangar?
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        self.animator = ParaMangar.renderAnimationOfView(self.targetView, duration: 1.0, delay: 0, options: UIViewAnimationOptions.allZeros, animations: {
            return
        }).toImage(1.0, completion: { image in
            self.animator = nil
            self.imageView.image = image
        })
    }
    
}
