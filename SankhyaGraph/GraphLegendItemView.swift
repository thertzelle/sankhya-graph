import UIKit

class GraphLegendItemView: UIView {
    let pattern: FillPattern
    
    private let patternView = UIView()
    
    init(pattern: FillPattern) {
        self.pattern = pattern
        
        super.init(frame: CGRect.zero)
        
        widthAnchor.constraintGreaterThanOrEqualToConstant(30).active = true
        
        setDimensionConstraint(.Height, constant: 30)
        
        patternView.translatesAutoresizingMaskIntoConstraints = false
        patternView.backgroundColor = pattern.color
        
        addSubview(patternView)
        
        patternView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 2).active = true
        patternView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        patternView.setDimensionConstraint(.Width, constant: 14)
        patternView.setDimensionConstraint(.Height, constant: 14)
        
        let patternDescription = UILabel()
        patternDescription.translatesAutoresizingMaskIntoConstraints = false
        
        patternDescription.text = pattern.description
        patternDescription.font = UIFont(name: "HelveticaNeue", size: 11)
        patternDescription.textAlignment = .Center
        
        addSubview(patternDescription)
        
        patternDescription.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        patternDescription.leftAnchor.constraintEqualToAnchor(patternView.rightAnchor, constant: 5).active = true
        patternDescription.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -5).active = true
        patternDescription.heightAnchor.constraintEqualToAnchor(patternView.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        patternView.makeCircular()
    }
}