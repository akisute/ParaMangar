//
//  ParaMangar.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/02/16.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit

public class ParaMangar: NSObject {
    
    private var render: (() -> Void)? = nil
    private var renderCompleted: (() -> Void)? = nil
    private var images: [UIImage] = []
    
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: "onDisplayLink:")
    private var targetView: UIView?
    
    public class func renderAnimationOfView(view: UIView, duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void) -> ParaMangar {
        let animator = ParaMangar()
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: nil)
        animator.targetView = view
        animator.displayLink.frameInterval = 1
        if (delay > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                animator.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            }
        } else {
            animator.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
        
        // TODO: should not use dispatch_after after all, it's not precise at all
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((duration+delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            animator.displayLink.invalidate()
            animator.renderCompleted?()
        }
        return animator
    }
    
    public class func renderView(view: UIView, frameCount: Int, updateBlock: (view: UIView, frame: Int) -> Void) -> ParaMangar {
        let animator = ParaMangar()
        animator.render = { [unowned animator] in
            for frame in 0..<frameCount {
                updateBlock(view: view, frame: frame)
                animator.renderFrame(view)
            }
            animator.renderCompleted?()
        }
        return animator
    }
    
    public func toImage(duration: NSTimeInterval, completion: (image: UIImage) -> Void) -> ParaMangar {
        self.renderCompleted = { [unowned self] in
            let image = UIImage.animatedImageWithImages(self.images, duration: duration)
            completion(image: image)
        }
        self.render?()
        return self
    }
    
    public func toFile(fileName: String, completion: (path: String) -> Void) -> ParaMangar {
        self.renderCompleted = { [unowned self] in
            NSFileManager.defaultManager().createDirectoryAtPath(self.imageDirectoryPath(fileName), withIntermediateDirectories: true, attributes: nil, error: nil)
            var index = 0
            for image in self.images {
                UIImagePNGRepresentation(image).writeToFile(self.imageFilePathForIndex(fileName, index: index), atomically: true)
                index++
            }
            completion(path: self.imageDirectoryPath(fileName))
        }
        self.render?()
        return self
    }
    
    // MARK: Actions
    
    func onDisplayLink(sender: CADisplayLink) {
        if let view = self.targetView {
            self.renderFrame(view)
        }
    }
    
    // MARK: Private
    
    private var documentsDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths.last as String
    }
    
    private func imageDirectoryPath(fileName: String) -> String {
        return self.documentsDirectory.stringByAppendingPathComponent(fileName)
    }

    private func imageFilePathForIndex(fileName: String, index: Int) -> String {
        return self.imageDirectoryPath(fileName).stringByAppendingPathComponent(NSString(format: "%@-%d@2x.png", fileName, index))
    }
    
    private func renderFrame(view: UIView) {
        self.images.append(view.paramangar_snapshotImage())
    }
    
}

extension UIView {
    private func paramangar_snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 2.0)
        let layer: CALayer = self.layer.presentationLayer() as? CALayer ?? self.layer
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}