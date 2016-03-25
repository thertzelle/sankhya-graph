import UIKit

class VerticalAxisView: UIView {
    private let graphPlotData: [GraphPlotData]
    private let axisViewItemWidth: CGFloat = 30.0
    
    init(graphPlotData: [GraphPlotData]) {
        self.graphPlotData = graphPlotData
        
        super.init(frame: CGRectZero)
        
        setDimensionConstraint(.Width, constant: axisViewItemWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateAxisItems() {
        (0...SankhyaGraph.numberOfIntervals).forEach({ intervalNumber in
            layer.insertSublayer(generateAxisItemTextLayer(intervalNumber, graphPlotData: graphPlotData), above: layer)
        })
    }
    
    func redoAxisItemHeight() {
        layer.sublayers?.filter({ ($0 as? CATextLayer) != nil }).forEach({ axisItemTextLayer in
            let existingItemHeight = axisItemTextLayer.frame.size.height
            let intervalNumber = axisItemTextLayer.frame.origin.y / existingItemHeight
            
            axisItemTextLayer.frame = CGRectMake(0.0, CGFloat(intervalNumber) * GraphDataUtil.axisItemHeight(), axisViewItemWidth - 5.0, GraphDataUtil.axisItemHeight())
        })
    }
    
    private func generateAxisItemTextLayer(intervalNumber:Int, graphPlotData: [GraphPlotData]) -> CATextLayer {
        let (maximumVerticalAxisValue, interval) = GraphDataUtil.verticalAxisValueProperties(graphPlotData)
        
        let axisItemText = Double(maximumVerticalAxisValue) - (Double(intervalNumber) * interval)
        
        let axisItemTextLayer = CATextLayer()
        
        axisItemTextLayer.frame = CGRectMake(0.0, CGFloat(intervalNumber) * GraphDataUtil.axisItemHeight(), axisViewItemWidth - 5.0, GraphDataUtil.axisItemHeight())
        
        axisItemTextLayer.font = "HelveticaNeue"
        axisItemTextLayer.fontSize = 12
        axisItemTextLayer.contentsScale = UIScreen.mainScreen().scale
        axisItemTextLayer.string = axisItemText.toString()
        axisItemTextLayer.alignmentMode = "right"
        axisItemTextLayer.foregroundColor = SankhyaGraph.graphAccentColor.CGColor
        
        return axisItemTextLayer
    }
}