import UIKit

class HorizontalAxisScrollView: UIScrollView, ContainerView {
    private let stackView: UIStackView
    
    init() {
        stackView = UIStackView()
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor.whiteColor()
        bounces = false
        
        stackView.axis = .Horizontal
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Leading
        stackView.spacing = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints(graphView: SankhyaGraph, graphPlotData: [GraphPlotData]) {
        addConstraintsToScrollView(graphView)
        addContraintsToStackView(graphView)
        
        buildAxisItems(graphView, graphPlotData: graphPlotData)
    }
    
    func removeAllSubviews() {
        stackView.arrangedSubviews.forEach({ stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
    }
    
    private func addConstraintsToScrollView(graphView: SankhyaGraph) {
        translatesAutoresizingMaskIntoConstraints = false
        
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: graphView, attribute: .CenterY, multiplier: 1.75, constant: 0))
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: graphView, attribute: .Right, multiplier: 1.0, constant: 0))
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: graphView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: graphView, attribute: .Left, multiplier: 1.0, constant: 0))
    }
    
    private func addContraintsToStackView(graphView: SankhyaGraph) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        graphView.addConstraintsOfPinnedViews(fromView: stackView, toView: self)
    }
    
    private func buildAxisItems(graphView: SankhyaGraph, graphPlotData: [GraphPlotData]) {
        for index in 0..<graphPlotData.count   {
            let graphDataPoint = graphPlotData[index]
            
            let horizontalAxisItem = HorizontalAxisItemView()
            horizontalAxisItem.translatesAutoresizingMaskIntoConstraints = false
            
            let horizontalAxisItemLabel = HorizontalAxisItemLabel()
            horizontalAxisItemLabel.translatesAutoresizingMaskIntoConstraints = false
            horizontalAxisItemLabel.text = "\(graphDataPoint.xAxis.hour()) \(graphDataPoint.xAxis.period())"
            
            horizontalAxisItem.addSubview(horizontalAxisItemLabel)
            
            stackView.addArrangedSubview(horizontalAxisItem)
            
            graphView.addConstraint(NSLayoutConstraint(item: horizontalAxisItemLabel, attribute: .Top, relatedBy: .Equal, toItem: horizontalAxisItem, attribute: .Top, multiplier: 1.0, constant: 0))
            graphView.addConstraint(NSLayoutConstraint(item: horizontalAxisItemLabel, attribute: .Bottom, relatedBy: .Equal, toItem: horizontalAxisItem, attribute: .Bottom, multiplier: 1.0, constant: 0))
            graphView.addConstraint(NSLayoutConstraint(item: horizontalAxisItemLabel, attribute: .CenterX, relatedBy: .Equal, toItem: horizontalAxisItem, attribute: .Left, multiplier: 1.0, constant: 0))
        }
    }
}