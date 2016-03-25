import UIKit

class GraphContainerScrollView: UIScrollView, ContainerView, GraphOverlay {
    private let stackView: UIStackView
    
    init() {
        stackView = UIStackView()
        
        super.init(frame: CGRectZero)
        
        contentInset.right = 50
        backgroundColor = SankhyaGraph.graphScrollViewBackgroundColor
        scrollEnabled = true
        bounces = false
        directionalLockEnabled = true
        
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Leading
        stackView.spacing = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints(graphView: SankhyaGraph, graphPlotData: [GraphPlotData]) {
        addConstraintsToScrollView(graphView)
        addContraintsToStackView(graphView)
    }
    
    func addGraphView(graphData: GraphData) {
        let graphViewContainer = GraphWrapperView(graphData: graphData)
        
        stackView.addArrangedSubview(graphViewContainer)
    }
    
    func removeAllSubviews() {
        stackView.arrangedSubviews.forEach({ stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
        subviews.forEach({ view in
            if view.tag == ViewType.OverlayView.rawValue {
                view.removeFromSuperview()
            }
        })
    }
    
    func applyStyle(colorModifiers: [ColorType], graphIndex: Int) {
        (stackView.subviews[graphIndex] as? GraphWrapperView)?.generateLinePath(colorModifiers)
    }
    
    func addVerticalBand(pattern: FillPattern, ranges: [GraphRange], graphIndex: Int?) {
        guard let graphIndex = graphIndex else {
            buildVerticalBand(pattern, ranges: ranges)
            
            return
        }
        
        (stackView.subviews[graphIndex] as? GraphWrapperView)?.buildVerticalBand(pattern, ranges: ranges)
    }
    
    func redoConstraints() {
        (stackView.subviews.filter({ ($0 as? GraphWrapperView) != nil }) as? [GraphWrapperView])?.forEach({ $0.redoConstraints() })
    }
    
    private func addConstraintsToScrollView(graphView: SankhyaGraph) {
        translatesAutoresizingMaskIntoConstraints = false
        graphView.pinView(self, layoutAnchors: [.Right,.Left])
        
        graphView.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: graphView, attribute: .CenterY, multiplier: 1.75, constant: 0))
    }
    
    private func addContraintsToStackView(graphView: SankhyaGraph) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        graphView.addConstraintsOfPinnedViews(fromView: stackView, toView: self)
    }
}