import UIKit

class IconDescriptionView: UILabel {
    init(text: String) {
        super.init(frame: CGRectZero)
        
        font = UIFont(name: "HelveticaNeue", size: 11)
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDimensionConstraints() {
        widthAnchor.constraintGreaterThanOrEqualToConstant(SankhyaGraph.imageSizeDimension).active = true
        widthAnchor.constraintLessThanOrEqualToConstant(SankhyaGraph.imageSizeDimension + 40).active = true
        
        heightAnchor.constraintEqualToConstant(16).active = true
    }
}