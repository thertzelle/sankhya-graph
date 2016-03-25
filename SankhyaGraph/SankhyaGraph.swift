import UIKit

@IBDesignable
public class SankhyaGraph: SankhyaGraphDesignable {
    private let graphContainerScrollView = GraphContainerScrollView()
    private let verticalAxisScrollView = VerticalAxisScrollView()
    private let horizontalAxisScrollView = HorizontalAxisScrollView()
    
    private let graphLegendView = GraphLegendView()
    
    private var graphData: [GraphData]?
    
    /**
     Generates one or more graphs inside the view.
     
     @param graphData Takes in an array of GraphData.
     
     Example:
     ```
     (dataPoints: [GraphPlotData], units: String?, image: UIImage?)
     ```
     */
    public func buildGraph(graphData graphData: [GraphData]) {
        self.graphData = graphData
        
        buildScrollViews(graphData)
        
        graphData.forEach({ graphDataItem in
            verticalAxisScrollView.addSectionView(graphDataItem)
            graphContainerScrollView.addGraphView(graphDataItem)
        })
        
        layoutIfNeeded()
    }
    
    /**
     Apply style for dots and lines for specific graph index
     
     @param colorModifiers Array of ColorType where each index represents interval on a graph. Size of colorModifiers array should match size of GraphData.
     @param graphIndex Specify which graph to apply the styles to.
     
     Example:
     ```
     applyStyleForData(colorModifiers: [.Custom(color: UIColor.redColor(), description: "Outlier"), .Standard], graphIndex: 0)
     ```
     */
    public func applyStyleForData(colorModifiers colorModifiers: [ColorType], graphIndex: Int) {
        graphContainerScrollView.applyStyle(colorModifiers, graphIndex: graphIndex)
        colorModifiers.flatMap({ colorModifier in colorModifier.toFillPattern() }).forEach({ pattern in graphLegendView.addLegendItem(pattern) })
    }
    
    /**
     Generates vertical bands for a given range.
     
     @param pattern Style to apply to vertical band (Color or Image)
     @param ranges Ranges that correspond to intervals in GraphData
     @param graphIndex Specify which graph to apply the styles to. If not specified, the vertical band will be generated for the all the graphs
     
     Example:
     ```
     verticalBandAtPosition(pattern: .Image(image: UIImage(named: "stripe"), description: "Rainfast"), ranges: [(startIndex: 3, endIndex: 4), (startIndex: 6, endIndex: 9)], graphIndex: 2)
     ```
     */
    public func verticalBandAtPosition(pattern: FillPattern, ranges: [GraphRange], graphIndex: Int? = nil) {
        graphContainerScrollView.addVerticalBand(pattern, ranges: ranges, graphIndex: graphIndex)
        graphLegendView.addLegendItem(pattern)
    }
    
    public func clearAllGraphs() {
        let containerTypeToViewDictionary = buildContainerTypeToViewDictionary()
        ContainerViewType.allValues().forEach({ (containerTypeToViewDictionary[$0] as? ContainerView)?.removeAllSubviews() })
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutGraph(graphData?.count ?? 0)
        
        verticalAxisScrollView.redoConstraints()
        graphContainerScrollView.redoConstraints()
    }
    
    private func buildScrollViews(graphData: [GraphData]) {
        guard let firstGraphData = graphData.first else { return }
        
        let containerTypeToViewDictionary = buildContainerTypeToViewDictionary()
        
        func buildView(containerViewType: ContainerViewType) {
            guard let containerView = containerTypeToViewDictionary[containerViewType] else { return }
            
            addSubview(containerView)
            
            (containerView as? UIScrollView)?.delegate = self
            (containerView as? ContainerView)?.setConstraints(self, graphPlotData: firstGraphData.dataPoints)
        }
        
        ContainerViewType.allValues().forEach({ buildView($0) })
        
        setGraphLegendViewConstraints()
        
        layoutGraph(graphData.count)
    }
    
    private func setGraphLegendViewConstraints() {
        graphContainerScrollView.topAnchor.constraintEqualToAnchor(graphLegendView.bottomAnchor).active = true
        verticalAxisScrollView.topAnchor.constraintEqualToAnchor(graphLegendView.bottomAnchor).active = true
    }
    
    private func layoutGraph(numberOfGraphs: Int) {
        layoutIfNeeded()
        
        GraphDataUtil.computeGraphHeight(numberOfGraphs, graphContainerScrollViewHeight: graphContainerScrollView.frame.size.height)
        
        graphContainerScrollView.contentInset.left = verticalAxisScrollView.frame.width
        horizontalAxisScrollView.contentInset.left = verticalAxisScrollView.frame.width
    }
    
    private func buildContainerTypeToViewDictionary() -> [ContainerViewType: UIView] {
        var containerTypeToViewDictionary = [ContainerViewType: UIView]()
        
        containerTypeToViewDictionary[.Graph] = graphContainerScrollView
        containerTypeToViewDictionary[.VerticalAxis] = verticalAxisScrollView
        containerTypeToViewDictionary[.HorizontalAxis] = horizontalAxisScrollView
        containerTypeToViewDictionary[.Legend] = graphLegendView
        
        return containerTypeToViewDictionary
    }
}

extension SankhyaGraph: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == graphContainerScrollView {
            verticalAxisScrollView.contentOffset.y = scrollView.contentOffset.y
            horizontalAxisScrollView.contentOffset.x = scrollView.contentOffset.x
        } else if scrollView == verticalAxisScrollView {
            graphContainerScrollView.contentOffset.y = scrollView.contentOffset.y
        } else if scrollView == horizontalAxisScrollView {
            graphContainerScrollView.contentOffset.x = scrollView.contentOffset.x
        }
    }
}