import UIKit

class IconView: UIImageView {
    override init(image: UIImage?) {
        super.init(frame: CGRectZero)
        
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints(constant constant: CGFloat) {
        setDimensionConstraint(.Width, constant: constant)
        setDimensionConstraint(.Height, constant: constant)
    }
}