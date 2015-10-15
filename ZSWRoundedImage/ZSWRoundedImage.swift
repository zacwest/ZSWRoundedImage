import UIKit

public struct RoundedResizingDirection : OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let Horizontal = RoundedResizingDirection(rawValue: 0b1)
    public static let Vertical = RoundedResizingDirection(rawValue: 0b10)
    public static let Both: RoundedResizingDirection = [Horizontal, Vertical]
}

extension UIColor {
    var isTranslucent: Bool {
        var alpha: CGFloat = 0
        if self.getRed(nil, green: nil, blue: nil, alpha: &alpha) {
            return alpha < 1.0
        } else {
            return false
        }
    }
}

extension UIImage {
    // this is not an initializer because we need to replace self with resizable version
    // and the language does not allow this
    public static func imageWithRoundedCorners(roundedCorners: UIRectCorner, cornerRadius: CGFloat, resizingDirection: RoundedResizingDirection, foregroundColor: UIColor, backgroundColor: UIColor, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> UIImage {
        // We adjust all our values to be in 1.0-scale space so smaller radii are less aliased
        let screenScale = UIScreen.mainScreen().scale
        let scaledCornerRadius = cornerRadius * screenScale
        var scaledSize = CGSize(width: scaledCornerRadius*2.0, height: scaledCornerRadius*2.0)
        
        if resizingDirection.contains(.Horizontal) {
            scaledSize.width += screenScale
        }
        
        if resizingDirection.contains(.Vertical) {
            scaledSize.height += screenScale
        }
        
        let anyTranslucent = foregroundColor.isTranslucent || backgroundColor.isTranslucent || (borderColor?.isTranslucent ?? false)
        UIGraphicsBeginImageContextWithOptions(scaledSize, !anyTranslucent, 1.0)
        
        // Fill the whole image with the background color
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: CGPoint(), size: scaledSize))
        
        let path = UIBezierPath(roundedRectWithoutAliasing: CGRect(origin: CGPoint(), size: scaledSize), byRoundingCorners: roundedCorners, cornerRadius: scaledCornerRadius)
        
        foregroundColor.setFill()
        path.fillWithBlendMode(.Copy, alpha: 1.0)
        
        if let borderWidth = borderWidth {
            // border is drawn at twice the size because it draws outside the path half of it
            borderColor?.setStroke()
            path.addClip()
            path.lineWidth = min(borderWidth * screenScale, cornerRadius) * 2.0
            path.strokeWithBlendMode(.Copy, alpha: 1.0)
        }
        
        let rawImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let image = UIImage(CGImage: rawImage.CGImage!, scale: screenScale, orientation: .Up)
        
        var capInsets = UIEdgeInsets()
        
        if resizingDirection.contains(.Vertical) {
            capInsets.top = cornerRadius
            capInsets.bottom = cornerRadius
        }
        
        if resizingDirection.contains(.Horizontal) {
            capInsets.left = cornerRadius
            capInsets.right = cornerRadius
        }
        
        return image.resizableImageWithCapInsets(capInsets, resizingMode: .Tile)
    }
}

extension UIBezierPath {
    // UIBezierPath's built-in roundedRect generator produces rectangles which 
    // are badly antialiased; it seems like it's trying too hard to produce _a_
    // result rather than producing a _good_ result. it's much cleaner to
    // create our own bezier path since we can control how it positions.
    
    convenience init(roundedRectWithoutAliasing frame: CGRect, byRoundingCorners corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = CGPathCreateMutable()
        
        func pointsForCorner(corner: UIRectCorner) -> (start: CGPoint, corner: CGPoint, end: CGPoint) {
            switch corner {
            case UIRectCorner.TopLeft:
                return (
                    start: CGPoint(x: frame.minX, y: frame.midY),
                    corner: CGPoint(x: frame.minX, y: frame.minY),
                    end: CGPoint(x: frame.midX, y: frame.minY)
                )
            case UIRectCorner.TopRight:
                return (
                    start: CGPoint(x: frame.midX, y: frame.minY),
                    corner: CGPoint(x: frame.maxX, y: frame.minY),
                    end: CGPoint(x: frame.maxX, y: frame.midY)
                )
            case UIRectCorner.BottomRight:
                return (
                    start: CGPoint(x: frame.maxX, y: frame.midY),
                    corner: CGPoint(x: frame.maxX, y: frame.maxY),
                    end: CGPoint(x: frame.midX, y: frame.maxY)
                )
            case UIRectCorner.BottomLeft:
                return (
                    start: CGPoint(x: frame.midX, y: frame.maxY),
                    corner: CGPoint(x: frame.minX, y: frame.maxY),
                    end: CGPoint(x: frame.minX, y: frame.midY)
                )
            default:
                break
            }
            
            return (CGPoint(), CGPoint(), CGPoint())
        }
        
        for corner in [.TopLeft, .TopRight, .BottomRight, .BottomLeft] as [UIRectCorner] {
            let (startPoint, cornerPoint, endPoint) = pointsForCorner(corner)
            if CGPathIsEmpty(path) {
                CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y)
            }
            
            if corners.contains(corner) && cornerRadius > 0 {
                CGPathAddArcToPoint(path, nil, cornerPoint.x, cornerPoint.y, endPoint.x, endPoint.y, cornerRadius)
            } else {
                CGPathAddLineToPoint(path, nil, cornerPoint.x, cornerPoint.y)
                CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y)
            }
        }
        
        CGPathCloseSubpath(path)
        
        self.init(CGPath: path)
    }
}
