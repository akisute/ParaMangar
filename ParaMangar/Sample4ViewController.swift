//
//  Sample4ViewController.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/03/11.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit
import QuartzCore
import ParaMangarLib

class Sample4ViewController: UIViewController {
    
    @IBOutlet var targetView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var render1SecButton: UIButton!
    
    var arcLayer: CAShapeLayer = CAShapeLayer()
    
    var animator: ParaMangar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arcLayer.strokeColor = UIColor.greenColor().CGColor
        self.arcLayer.fillColor = UIColor.clearColor().CGColor
        self.arcLayer.lineWidth = 10
        self.arcLayer.lineCap = kCALineCapRound
        self.arcLayer.strokeStart = 0.0
        self.arcLayer.strokeEnd = 1.0
        
        self.targetView.layer.addSublayer(self.arcLayer)
        
        self.updateArcLayerPath()
    }
    
    @IBAction func onRender1SecButton(sender: UIButton) {
        /*
        self.animator = ParaMangar.renderView(self.targetView, frameCount: 60, updateBlock: { view, frame in
            self.arcLayer.strokeEnd = CGFloat(frame) * (1.0 / 60.0)
            self.updateArcLayerPath()
        }).toImage(1.0, completion: { image in
            self.animator = nil
            self.render1SecButton.setTitle("Completed!", forState: UIControlState.Normal)
            self.imageView.image = image
        })
*/
        self.animator = ParaMangar.renderView(self.targetView, frameCount: 60, updateBlock: { view, frame in
            self.arcLayer.strokeEnd = CGFloat(frame) * (1.0 / 60.0)
            self.updateArcLayerPath()
        }).toFile("Sample4", completion: { (path) -> Void in
            self.animator = nil
            println("\(path)")
        })
    }
    
    private func updateArcLayerPath() {
        let size = self.targetView.bounds.size
        let rect = CGRect(
            x: self.arcLayer.lineWidth / 2.0,
            y: self.arcLayer.lineWidth / 2.0,
            width: size.width - self.arcLayer.lineWidth,
            height: size.height - self.arcLayer.lineWidth)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: size.width)
        self.arcLayer.position = CGPoint(x: 0, y: 0)
        self.arcLayer.path = path.CGPath
        //self.arcLayer.setNeedsDisplay()
        //self.arcLayer.displayIfNeeded()
    }
    
}
