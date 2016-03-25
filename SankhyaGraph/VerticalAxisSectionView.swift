import UIKit

class VerticalAxisSectionView: UIView {
    private var heightConstraint: NSLayoutConstraint?
    
    init(graphPlotData: [GraphPlotData]) {
        super.init(frame: CGRectZero)
        
        let sectionBorderView = AxisSectionBorderView(dimension: .Width)
        sectionBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionBorderView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = setDimensionConstraint(.Height, constant: SankhyaGraph.graphHeight)
        
        pinView(sectionBorderView, layoutAnchors: [.Bottom, .Right, .Top])
        
        addVerticalAxisView(graphPlotData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraintsOnStackView(stackView: UIStackView) {
        pinView(stackView, layoutAnchors: [.Left, .Right])
    }
    
    func addConstraintToIconDescription(iconDescription: IconDescriptionView) {
        if let verticalAxisView = subviews.findFirst({ ($0 as? VerticalAxisView) != nil }) as? VerticalAxisView {
            iconDescription.rightAnchor.constraintEqualToAnchor(verticalAxisView.leftAnchor).active = true
        }
    }
    
    func redoConstraints() {
        if heightConstraint != nil { removeConstraints([heightConstraint!]) }
        
        heightConstraint = setDimensionConstraint(.Height, constant: SankhyaGraph.graphHeight)
        
        (subviews.findFirst({ ($0 as? VerticalAxisView) != nil }) as? VerticalAxisView)?.redoAxisItemHeight()
    }
    
    private func addVerticalAxisView(graphPlotData: [GraphPlotData]) {
        let verticalAxisView = VerticalAxisView(graphPlotData: graphPlotData)
        verticalAxisView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalAxisView.generateAxisItems()
        
        addSubview(verticalAxisView)
        
        verticalAxisView.pinView(self, layoutAnchors: [.Top, .Right, .Bottom])
    }
}