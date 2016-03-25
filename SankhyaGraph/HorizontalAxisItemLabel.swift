import UIKit

class HorizontalAxisItemLabel: UILabel {
    init() {
        super.init(frame: CGRectZero)
        
        textColor = SankhyaGraph.graphAccentColor
        font = UIFont(name: "HelveticaNeue", size: 12)
        textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
