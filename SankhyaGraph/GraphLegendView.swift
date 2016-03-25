import UIKit

class GraphLegendView: UIView, ContainerView {
    let stackView: UIStackView
    
    init() {
        stackView = UIStackView()
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor.whiteColor()
        
        stackView.axis = .Horizontal
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Center
        stackView.spacing = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAllSubviews() {
        stackView.arrangedSubviews.forEach({ stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
    }
    
    func setConstraints(graphView: SankhyaGraph, graphPlotData: [GraphPlotData]) {
        addConstraintsToLegendView(graphView)
        addConstraintsToLegendStackView(graphView)
    }
    
    private func addConstraintsToLegendView(graphView: SankhyaGraph) {
        translatesAutoresizingMaskIntoConstraints = false
        
        graphView.pinView(self, layoutAnchors: [.Top, .Left, .Right])
        setDimensionConstraint(.Height, constant: 30)
    }
    
    private func addConstraintsToLegendStackView(graphView: SankhyaGraph) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.pinView(self, layoutAnchors: [.Top, .Bottom])
        stackView.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -15).active = true
        stackView.leftAnchor.constraintGreaterThanOrEqualToAnchor(leftAnchor, constant: 125)
    }
    
    func addLegendItem(pattern: FillPattern) {
        if stackView.subviews.findFirst({ ($0 as? GraphLegendItemView)?.pattern.description == pattern.description }) == nil {
            stackView.addArrangedSubview(GraphLegendItemView(pattern: pattern))
        }
    }
}