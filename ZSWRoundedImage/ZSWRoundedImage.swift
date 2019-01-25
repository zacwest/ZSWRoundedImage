import UIKit

public struct RoundedResizingDirection: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let horizontal = RoundedResizingDirection(rawValue: 0b1)
    public static let vertical = RoundedResizingDirection(rawValue: 0b10)
    public static let both: RoundedResizingDirection = [.horizontal, .vertical]
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
    // resizing can only be set with the -resizableImage method https://developer.apple.com/documentation/uikit/uiimage/1624157-resizingmode
    public static func image(roundedCorners: UIRectCorner, cornerRadius: CGFloat, resizingDirection: RoundedResizingDirection, foregroundColor: UIColor, backgroundColor: UIColor, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) -> UIImage {
        // We adjust all our values to be in 1.0-scale space so smaller radii are less aliased
        let screenScale = UIScreen.main.scale
        let scaledCornerRadius = cornerRadius * screenScale
        var scaledSize = CGSize(width: scaledCornerRadius*2.0, height: scaledCornerRadius*2.0)
        
        if resizingDirection.contains(.horizontal) {
            scaledSize.width += screenScale
        }
        
        if resizingDirection.contains(.vertical) {
            scaledSize.height += screenScale
        }
        
        let anyTranslucent = foregroundColor.isTranslucent || backgroundColor.isTranslucent || (borderColor?.isTranslucent ?? false)
        UIGraphicsBeginImageContextWithOptions(scaledSize, !anyTranslucent, 1.0)
        
        // Fill the whole image with the background color
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: CGPoint(), size: scaledSize))
        
        let path = UIBezierPath(roundedRectWithoutAliasing: CGRect(origin: CGPoint(), size: scaledSize), byRoundingCorners: roundedCorners, cornerRadius: scaledCornerRadius)
        
        foregroundColor.setFill()
        path.fill(with: .copy, alpha: 1.0)
        
        if let borderWidth = borderWidth {
            // border is drawn at twice the size because it draws outside the path half of it
            borderColor?.setStroke()
            path.addClip()
            path.lineWidth = min(borderWidth * screenScale, cornerRadius) * 2.0
            path.stroke(with: .copy, alpha: 1.0)
        }
        
        let rawImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let image = UIImage(cgImage: rawImage.cgImage!, scale: screenScale, orientation: .up)
        
        var capInsets = UIEdgeInsets()
        
        if resizingDirection.contains(.vertical) {
            capInsets.top = cornerRadius
            capInsets.bottom = cornerRadius
        }
        
        if resizingDirection.contains(.horizontal) {
            capInsets.left = cornerRadius
            capInsets.right = cornerRadius
        }
        
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .tile)
    }
}

extension UIBezierPath {
    // UIBezierPath's built-in roundedRect generator produces rectangles which 
    // are badly antialiased; it seems like it's trying too hard to produce _a_
    // result rather than producing a _good_ result. it's much cleaner to
    // create our own bezier path since we can control how it positions.
    
    convenience init(roundedRectWithoutAliasing frame: CGRect, byRoundingCorners corners: UIRectCorner, cornerRadius: CGFloat) {
        var path = CGMutablePath()
        
        func pointsForCorner(corner: UIRectCorner) -> (start: CGPoint, corner: CGPoint, end: CGPoint) {
            switch corner {
            case UIRectCorner.topLeft:
                return (
                    start: CGPoint(x: frame.minX, y: frame.midY),
                    corner: CGPoint(x: frame.minX, y: frame.minY),
                    end: CGPoint(x: frame.midX, y: frame.minY)
                )
            case UIRectCorner.topRight:
                return (
                    start: CGPoint(x: frame.midX, y: frame.minY),
                    corner: CGPoint(x: frame.maxX, y: frame.minY),
                    end: CGPoint(x: frame.maxX, y: frame.midY)
                )
            case UIRectCorner.bottomRight:
                return (
                    start: CGPoint(x: frame.maxX, y: frame.midY),
                    corner: CGPoint(x: frame.maxX, y: frame.maxY),
                    end: CGPoint(x: frame.midX, y: frame.maxY)
                )
            case UIRectCorner.bottomLeft:
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
        
        for corner in [.topLeft, .topRight, .bottomRight, .bottomLeft] as [UIRectCorner] {
            let (startPoint, cornerPoint, endPoint) = pointsForCorner(corner: corner)
            if path.isEmpty {
                path.move(to: startPoint)
            }
            
            if corners.contains(corner) && cornerRadius > 0 {
                path.addArc(tangent1End: cornerPoint, tangent2End: endPoint, radius: cornerRadius)
            } else {
                path.addLine(to: cornerPoint)
                path.addLine(to: endPoint)
            }
        }
        
        path.closeSubpath()
        
        self.init(cgPath: path)
    }
}
