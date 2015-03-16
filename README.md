#ParaMangar

ParaMangar is a swift library to make UIImage animations more convenient for you, especially useful when it comes to Apple Watch development.
ParaMangar renders ordinal `UIView` or `CALayer` animations into animations that you can easily utilize for WatchKit.
This project is heavily inspired by [frosty/Flipbook](https://github.com/frosty/Flipbook) and is trying to improve it by several ways,
including makeing API more swift-like syntax, adding dynamic UIImage generation, and so on.

ParaMangar is licensed under the MIT license.

## Usage

ParaMangar has 2 usages: it can be used to generate static PNG files to be loaded as an animated UIImage,
or it can make an dynamic animating UIImage on runtime.

### Generate static image files

You can start making static image files by cloning this repository and open `ParaMangar.xcodeproj`.
In the project, You can find a target named `ParaMangar` and this is your playground.
ParaMangar renders `UIView` or `CALayer` into static image files so what you have to do is just make your own custom `UIView`
or `CALayer` that animates in this playground.

Once you finished making your views,

```swift
import ParaMangarLib
```

to import then ParaMangar library, then render your animation by:

```swift
let name = "Sample1"
let duration = 1.0
self.animator = ParaMangar.renderViewForDuration(self.targetView, duration: duration, frameInterval: 2).toFile(name, completion: {path in
    self.animator = nil
    println("Completed: \(path)")
    return
})
```

assuming `self.targetView` is already animating. This example keeps rendering the `self.targetView` for 1 seconds then export it to directory `path`.
The `path` contains multiple sequential PNG files that can be imported to your project and can be directly used by
`UIImage.animatedImageNamed(name, duration: duration)`.

The project provides several examples so feel free to look at them if you need more help.

### Generate dynamic UIImage on runtime

In this case you need to install ParaMangar as a library to your own project.

> TODO: make this project cocoapods-ready. carthage support is also a great option.

Once the import is done, everything you have to do is same except you call `toImage(duration, completion: completion)`
instead of `toFile(fileName, completion: completion)`, like this:

```swift
let duration = 1.0
self.animator = ParaMangar.renderViewForDuration(self.targetView, duration: duration, frameInterval: 2).toImage(duration, completion: {image in
    self.animator = nil
    self.imageView.image = image
    self.imageView.startAnimating()
    return
})
```

Alternatively, you can give this image to your WatchKit Extension as a cache to render it in WKInterfaceImage.



## API Reference

```
ParaMangar.renderViewForDuration(view: UIView, duration: NSTimeInterval, frameInterval: Int = 1, block: (() -> Void)? = nil) -> ParaMangar
```

Returns a ParaMangar object that renders the specified `view` for specified `duration`.

- `frameInterval`: how many frames skipped during rendering. if your specify 1, FPS will likely be 60 (60/1) and if you specify 2 it will be 30 (60/2).
- `block`: do something in this block if you wish do something when rendering is about to begin, especially like giving the `targetView` an animation.

Make sure to keep the returned ParaMangar object strongly referenced until rendering is finished.

----

```
ParaMangar.renderView(view: UIView, frameCount: Int, updateBlock: (view: UIView, frame: Int) -> Void) -> ParaMangar
```

Returns a ParaMangar object that renders the specified `view` in `updateBlock` for `frameCount` frames.

- `frameCount`: how many frames do you wan to render in this animation.
- `updateBlock`: in this block you render `view`. `frame` is the current frame count.

Make sure to keep the returned ParaMangar object strongly referenced until rendering is finished.

----

```
toImage(duration: NSTimeInterval, completion: (image: UIImage) -> Void)
```

Designates this ParaMangar object to render results into dynamic animated UIImage.

- `duration`: duration of animation for the result image.
- `completion`: called when rendering is completed. At this point you can dereference the ParaMangar object.

Once rendering is finished, you can't reuse the ParaMangar object again.

----

```
toFile(fileName: String, completion: (path: String) -> Void)
```

Designates this ParaMangar object to render results into sequential PNG files that can be loaded using `UIImage.animatedImageNamed(name, duration: duration)`.

- `fileName`: file name, used as prefixes of files.
- `completion`: called when rendering is completed. At this point you can dereference the ParaMangar object.

Once rendering is finished, you can't reuse the ParaMangar object again.

## Known Issues

Example 4, `ParaMangar.renderView(view, frameCount: frameCount, updateBlock: updateBlock)` DOESN'T WORK ;(
I guess something is wrong with Auto Layout animations but no ideas to fix this...
