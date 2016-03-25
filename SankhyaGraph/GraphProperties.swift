import UIKit

enum LineType {
    case Solid
    case Dashed
    
    static let dashedLineName = "DashedLine"
    
    func applyStyle(lineLayer: CAShapeLayer, color: CGColor) {
        lineLayer.fillColor = UIColor.clearColor().CGColor
        
        switch self {
        case .Solid:
            lineLayer.lineWidth = 2
            lineLayer.strokeColor = color
        case .Dashed:
            lineLayer.lineWidth = 2
            lineLayer.name = LineType.dashedLineName
            lineLayer.lineDashPattern = [5, 5]
            lineLayer.strokeColor = SankhyaGraph.dashedLineColor.CGColor
        }
    }
}

enum ViewType: NSInteger {
    case Default = 0
    case OverlayView = 5
}

protocol GraphOverlay {
    func buildVerticalBand(pattern: FillPattern, ranges: [GraphRange])
}

extension GraphOverlay where Self: UIView {
    func buildVerticalBand(pattern: FillPattern, ranges: [GraphRange]) {
        ranges.forEach({ range in
            let overlayView = UIView()
            
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.backgroundColor = pattern.color
            overlayView.alpha = 0.5
            overlayView.tag = ViewType.OverlayView.rawValue
            
            insertSubview(overlayView, atIndex: 0)
            
            overlayView.pinView(self, layoutAnchors: [.Top, .Bottom])
            overlayView.setDimensionConstraint(.Width, constant: CGFloat((range.endIndex - range.startIndex) * SankhyaGraph.horizontalItemWidth))
            
            overlayView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: CGFloat(range.startIndex * SankhyaGraph.horizontalItemWidth)).active = true
        })
    }
}