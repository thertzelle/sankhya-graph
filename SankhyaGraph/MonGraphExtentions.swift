import UIKit

enum LayoutAnchor {
    case Top
    case Bottom
    case Left
    case Right
    
    static func allValues() -> [LayoutAnchor] {
        return [.Top, .Bottom, .Right, .Left]
    }
}

enum DimensionAnchor {
    case Width
    case Height
}

extension Array {
    func findFirst(includeElement: (Element) -> Bool) -> (Element)? {
        return findFirstWithIndex(includeElement)?.0
    }
    
    func findFirstWithIndex(includeElement: (Element) -> Bool) -> (element: Element, index: Int)? {
        for index in 0..<self.count {
            if includeElement(self[index]) {
                return (self[index], index)
            }
        }
        
        return nil
    }
}

extension NSDate {
    func datesForNextHours(hours: Int) -> [NSDate] {
        let timestamp = self.timeIntervalSince1970
        let currentHour = timestamp - fmod(timestamp, 3600)
        
        return (1...hours).reduce([]) { (dates, index) -> [NSDate] in dates + [NSDate(timeIntervalSince1970: currentHour + Double(index * 3600))] }
    }
    
    func dateForNextHour() -> NSDate {
        return datesForNextHours(1).first ?? self
    }
    
    func hour() -> String {
        let format = NSDateFormatter()
        format.dateFormat = "h"
        format.timeZone = NSTimeZone.localTimeZone()
        return format.stringFromDate(self)
    }
    
    func period() -> String {
        let format = NSDateFormatter()
        format.dateFormat = "aaa"
        format.timeZone = NSTimeZone.localTimeZone()
        return format.stringFromDate(self)
    }
}

extension UIColor {
    static func grayVariantCGColor() -> CGColorRef {
        return UIColor(red: 152.0/255.0, green: 152.0/255, blue: 152.0/255.0, alpha: 1).CGColor
    }
    
    static func defaultAluminum() -> UIColor {
        return UIColor(red: 181.0/255.0, green: 183.0/255.0, blue: 172.0/255.0, alpha: 1)
    }
    
    static func defaultDarkAluminum() -> UIColor {
        return UIColor(red: 110.0/255.0, green: 106.0/255.0, blue: 172.0/255.0, alpha: 1)
    }
    
    static func defaultVerticalBandColor() -> UIColor {
        return UIColor(red: 160.0/255.0, green: 226.0/255.0, blue: 232.0/255.0, alpha: 1)
    }
    
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
    
    func isDark() -> Bool {
        guard let components = coreImageColor else { return true }
        
        return ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000 < 0.5
    }
    
    func contrastColor() -> UIColor {
        return isDark() ? UIColor.whiteColor() : UIColor.blackColor()
    }
}

extension Double {
    func toString(format: String = "%.0f") -> String {
        return String(format: format, self)
    }
}

extension UIView {
    func pinView(subView: UIView, layoutAnchors: [LayoutAnchor]? = nil) {
        (layoutAnchors ?? LayoutAnchor.allValues()).forEach({ constraintForLayoutAnchor(fromView: self, toView: subView, layoutAnchor: $0).active = true })
    }
    
    func addConstraintsOfPinnedViews(fromView fromView: UIView, toView: UIView, layoutAnchors: [LayoutAnchor]? = nil) {
        (layoutAnchors ?? LayoutAnchor.allValues()).forEach({ addConstraint(constraintForLayoutAnchor(fromView: fromView, toView: toView, layoutAnchor: $0)) })
    }
    
    func setDimensionConstraint(dimension: DimensionAnchor, constant: CGFloat) -> NSLayoutConstraint {
        switch dimension {
        case .Width:
            let widthConstraint = widthAnchor.constraintEqualToConstant(constant)
            widthConstraint.active = true
            
            return widthConstraint
        case .Height:
            let heightConstraint = heightAnchor.constraintEqualToConstant(constant)
            heightConstraint.active = true
            
            return heightConstraint
        }
    }
    
    func makeCircular() {
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }
    
    private func constraintForLayoutAnchor(fromView fromView: UIView, toView: UIView, layoutAnchor: LayoutAnchor) -> NSLayoutConstraint {
        switch layoutAnchor {
        case .Top: return fromView.topAnchor.constraintEqualToAnchor(toView.topAnchor)
        case .Right: return fromView.rightAnchor.constraintEqualToAnchor(toView.rightAnchor)
        case .Bottom: return fromView.bottomAnchor.constraintEqualToAnchor(toView.bottomAnchor)
        case .Left: return fromView.leftAnchor.constraintEqualToAnchor(toView.leftAnchor)
        }
    }
}