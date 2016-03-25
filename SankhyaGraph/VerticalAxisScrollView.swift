import UIKit

class VerticalAxisScrollView: UIScrollView, ContainerView {
    private let stackView: UIStackView
    
    init() {
        stackView = UIStackView()
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor.whiteColor()
        bounces = false
        
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Leading
        stackView.spacing = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redoConstraints() {
        (stackView.subviews.filter({ ($0 as? VerticalAxisSectionView) != nil }) as? [VerticalAxisSectionView])?.forEach({
            $0.redoConstraints()
        })
    }
    
    func removeAllSubviews() {
        stackView.arrangedSubviews.forEach({ stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
    }
    
    func setConstraints(graphView: SankhyaGraph, graphPlotData: [GraphPlotData]) {
        addConstraintsToScrollView(graphView)
        addContraintsToStackView(graphView)
    }
    
    func addSectionView(graphData: GraphData) {
        let verticalAxisSectionView = VerticalAxisSectionView(graphPlotData: graphData.dataPoints)
        stackView.addArrangedSubview(verticalAxisSectionView)
        
        verticalAxisSectionView.setConstraintsOnStackView(stackView)
        
        guard graphData.units != nil && graphData.image != nil else { return }
        
        let iconDescription = IconDescriptionView(text: graphData.units ?? "")
        iconDescription.translatesAutoresizingMaskIntoConstraints = false
        
        verticalAxisSectionView.addSubview(iconDescription)
        
        iconDescription.setDimensionConstraints()
        
        verticalAxisSectionView.addConstraintToIconDescription(iconDescription)
        
        iconDescription.leftAnchor.constraintEqualToAnchor(verticalAxisSectionView.leftAnchor, constant: 15).active = true
        
        if let icon = graphData.image {
            let iconView = IconView(image: icon)
            iconView.translatesAutoresizingMaskIntoConstraints = false
            
            verticalAxisSectionView.addSubview(iconView)
            
            iconView.setConstraints(constant: SankhyaGraph.imageSizeDimension)
            
            iconView.centerXAnchor.constraintEqualToAnchor(iconDescription.centerXAnchor).active = true
            iconView.centerYAnchor.constraintEqualToAnchor(verticalAxisSectionView.centerYAnchor).active = true
            
            iconDescription.topAnchor.constraintEqualToAnchor(iconView.bottomAnchor).active = true
        } else {
            iconDescription.centerYAnchor.constraintEqualToAnchor(verticalAxisSectionView.centerYAnchor).active = true
        }
    }
    
    private func addConstraintsToScrollView(graphView: SankhyaGraph) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraintGreaterThanOrEqualToConstant(SankhyaGraph.verticalAxisScrollViewWidth).active = true
        
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: graphView, attribute: .CenterY, multiplier: 1.75, constant: 0))
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: graphView, attribute: .Left, multiplier: 1.0, constant: 0))
    }
    
    private func addContraintsToStackView(graphView: SankhyaGraph) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.pinView(self, layoutAnchors: [.Top,.Bottom,.Left])
        stackView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
    }
}