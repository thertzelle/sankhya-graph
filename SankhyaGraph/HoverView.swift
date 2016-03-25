import UIKit

class HoverView: UIView {
    private let hoverLabel: UILabel
    
    override init(frame: CGRect) {
        hoverLabel = UILabel(frame: CGRectMake(10.0, 0, 100, 25.0))
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        let hoverViewPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(hoverViewPath, nil, 10.0, 0.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 110.0, 0.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 110.0, 25.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 10.0, 25.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 10.0, 25.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 0.0, 10.0)
        CGPathAddLineToPoint(hoverViewPath, nil, 10.0, 0.0)
        
        let hoverViewShapeLayer = CAShapeLayer()
        
        hoverViewShapeLayer.path = hoverViewPath
        hoverViewShapeLayer.fillColor = SankhyaGraph.hoverViewFillColor.CGColor
        hoverViewShapeLayer.strokeColor = SankhyaGraph.hoverViewStrokeColor.CGColor
        hoverViewShapeLayer.lineWidth = 1
        hoverViewShapeLayer.bounds = CGRectMake(0.0,0.0,120.0,25.0)
        hoverViewShapeLayer.anchorPoint = CGPointMake(0.0,0.0)
        hoverViewShapeLayer.position = CGPointMake(0.0,0.0)
        hoverViewShapeLayer.shadowColor = UIColor.lightGrayColor().CGColor
        hoverViewShapeLayer.shadowRadius = 3.0
        hoverViewShapeLayer.shadowOpacity = 0.9
        hoverViewShapeLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        hoverViewShapeLayer.contentsScale = UIScreen.mainScreen().scale
        
        layer.addSublayer(hoverViewShapeLayer)
        
        hoverLabel.textColor = SankhyaGraph.hoverViewFillColor.contrastColor()
        hoverLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        hoverLabel.textAlignment = .Center
        hoverLabel.contentMode = .ScaleToFill
        
        addSubview(hoverLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextOnHoverLabel(text: String) {
        hoverLabel.text = text
    }
}
