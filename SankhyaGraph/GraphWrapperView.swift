import UIKit

class GraphWrapperView: UIView, GraphOverlay {
    private let graphView: GraphView
    private var colorModifiers: [ColorType]?
    
    init(graphData: GraphData) {
        graphView = GraphView(graphData: graphData)
        
        super.init(frame: CGRect.zero)
        
        let borderView = AxisSectionBorderView(dimension: .Height)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(borderView)
        
        pinView(borderView, layoutAnchors: [.Bottom, .Right, .Left])
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(graphView)
        
        pinView(graphView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateLinePath(colorModifiers: [ColorType]) {
        self.colorModifiers = colorModifiers
        graphView.generateLinePath(colorModifiers)
    }
    
    func redoConstraints() {
        graphView.redrawLinePaths(colorModifiers)
    }
}
