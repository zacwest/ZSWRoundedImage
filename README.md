# ZSWRoundedImage

[![Version](https://img.shields.io/cocoapods/v/ZSWRoundedImage.svg?style=flat)](http://cocoapods.org/pods/ZSWRoundedImage) [![License](https://img.shields.io/cocoapods/l/ZSWRoundedImage.svg?style=flat)](http://cocoapods.org/pods/ZSWRoundedImage) [![Platform](https://img.shields.io/cocoapods/p/ZSWRoundedImage.svg?style=flat)](http://cocoapods.org/pods/ZSWRoundedImage)

ZSWRoundedImage is an extension of `UIImage` for creating resizable images with any of the corners rounded. This library does not yet work with Objective-C as it's part of the application I'm writing to learn Swift.

## Why an image?

You may be asking yourself, "why not round the `CALayer` instead of setting a background image?" This requires clipping the contents and adds transparency, both of which hurt performance. Using a background image allows creating fully opaque views while preserving the visual impact of rounded corners.

## Usage

This adds a single public method to UIImage:

```swift
extension UIImage {
    public static func imageWithRoundedCorners(
        roundedCorners: UIRectCorner,
        cornerRadius: CGFloat,
        resizingDirection: RoundedResizingDirection,
        foregroundColor: UIColor,
        backgroundColor: UIColor,
        borderColor: UIColor? = default,
        borderWidth: CGFloat? = default
    ) -> UIImage
}
```

To start, import the library:

```swift
import ZSWRoundedImage
```

and set the image in a `UIImageView`:

```
imageView.image = UIImage.imageWithRoundedCorners(
    .AllCorners, cornerRadius: 10.0,
    resizingDirection: .Both,
    foregroundColor: UIColor.blackColor(),
    backgroundColor: UIColor.clearColor()
)
```

## Resizing direction

A common design requirement is a background that looks like a pill. You create this by specifying a `cornerRadius` equal to half the height of your display. By default, this library adds a tiling pixel so the image can resize in any direction; this tiling pixel throws off the clean circular look of the pill. To eliminate this tiling pixel, pass either `.Horizontal` or `.Vertical` for the resizing direction, and it will not include one.

## Why isn't this a UIImage init method?

Good question, curious explorer! This is not an init method because creating a resizable `UIImage` requires a combination of initialization and copying-again-with-arguments. Swift init methods cannot change the return value or assign to self, so as of at least Swift 2.0 this is not possible. This was filed as [23128341](http://www.openradar.me/radar?id=5053670215385088).

## Why are you creating your own `UIBezierPath`?

The pursuit of clean edges and retina images. The system-provided rounding rectangle function for UIBezierPath is very badly anti-aliased because it draws at non-integral point locations. This library's primary purpose is to draw extremely clean lines, and so a custom path was necessary.

## Installation

ZSWRoundedImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZSWRoundedImage", "~> 1.0"
```

## License

ZSWRoundedImage is available under the MIT license. See the LICENSE file for more info.
