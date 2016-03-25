import UIKit

class AxisSectionBorderView: UIView {
    init(dimension: DimensionAnchor) {
        super.init(frame: CGRectZero)
        
        backgroundColor = SankhyaGraph.graphAccentColor
        
        setDimensionConstraint(dimension, constant: 1.10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}