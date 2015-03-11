//
//  ParaMangar.swift
//  ParaMangar
//
//  Created by Ono Masashi on 2015/02/16.
//  Copyright (c) 2015年 akisute. All rights reserved.
//

import UIKit

public class ParaMangar: NSObject {
    
    // Common ivar
    private var render: (() -> Void)? = nil
    private var renderCompleted: (() -> Void)? = nil
    private var images: [UIImage] = []
    // Duration Mode only ivar
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: "onDisplayLink:")
    private var displayLinkTargetView: UIView!
    private var displayLinkStartTime: NSTimeInterval?
    private var displayLinkDuration: NSTimeInterval!
    
    public class func renderViewForDuration(view: UIView, duration: NSTimeInterval, frameInterval: Int = 1, block: (() -> Void)? = nil) -> ParaMangar {
        let animator = ParaMangar()
        animator.displayLinkTargetView = view
        animator.displayLinkDuration = duration
        animator.displayLink.frameInterval = frameInterval
        animator.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        if let b = block {
            b()
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
        if self.displayLinkStartTime == nil {
            self.displayLinkStartTime = self.displayLink.timestamp
        }
        let startTime = self.displayLinkStartTime!
        
        self.renderFrame(self.displayLinkTargetView)
        
        if self.displayLink.timestamp - startTime > self.displayLinkDuration {
            self.displayLink.invalidate()
            self.renderCompleted?()
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