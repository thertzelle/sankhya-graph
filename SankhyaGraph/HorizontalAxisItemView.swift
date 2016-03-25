import UIKit

class HorizontalAxisItemView: UIView {
    init() {
        super.init(frame: CGRectZero)
        
        setDimensionConstraint(.Width, constant: CGFloat(SankhyaGraph.horizontalItemWidth - 1))
        setDimensionConstraint(.Height, constant: 20)
        
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}