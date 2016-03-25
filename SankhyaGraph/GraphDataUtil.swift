import UIKit

private let minimumGraphThreshold = 30.0
private let offset: CGFloat = 8

class GraphDataUtil {
    class func verticalAxisValueProperties(graphPlotData: [GraphPlotData]) -> (maximumValue: Int, interval: Double) {
        func computeMaximumValueForInterval(maximumValue: Double = minimumGraphThreshold) -> (Int, Double) {
            let interval = ceil(maximumValue / Double(SankhyaGraph.numberOfIntervals))
            
            return (Int(interval) * SankhyaGraph.numberOfIntervals, interval)
        }
        
        guard let max = graphPlotData.map({ $0.yAxis }).maxElement() else { return computeMaximumValueForInterval() }
        
        return computeMaximumValueForInterval(ceil(max <= minimumGraphThreshold ? minimumGraphThreshold : max))
    }
    
    class func computeGraphHeight(numberOfGraphs: Int, graphContainerScrollViewHeight: CGFloat) {
        if numberOfGraphs == 1 || numberOfGraphs == 2 {
            SankhyaGraph.graphHeight = (graphContainerScrollViewHeight - CGFloat(numberOfGraphs) * offset) / CGFloat(numberOfGraphs)
        }
    }
    
    class func axisItemHeight() -> CGFloat {
        return (SankhyaGraph.graphHeight - offset) / CGFloat(SankhyaGraph.numberOfIntervals)
    }
    
    class func multiplier(graphPlotData: [GraphPlotData]) -> CGFloat {
        let actualGraphHeight = SankhyaGraph.graphHeight - offset
        
        return actualGraphHeight / CGFloat(GraphDataUtil.verticalAxisValueProperties(graphPlotData).maximumValue)
    }
}