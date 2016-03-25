import UIKit

class GraphView: UIView {
    private let graphData: GraphData
    
    private let circleLayerName = "Circle"
    
    private let keyForXValue = "xValue"
    private let keyForYValue = "yValue"
    
    private let keyForXPosition = "xPosition"
    private let keyForYPosition = "yPosition"
    
    private var heightConstraint: NSLayoutConstraint?
    
    init(graphData: GraphData) {
        self.graphData = graphData
        
        super.init(frame:CGRectZero)
        
        backgroundColor = UIColor.clearColor()
        
        generateLinePath()
        
        setGraphSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redrawLinePaths(colorModifiers: [ColorType]?) {
        clearAllLines()
        
        generateLinePath(colorModifiers)
        
        setGraphSize()
    }
    
    func generateLinePath(colorModifiers: [ColorType]? = nil, index: Int = 0) {
        guard let firstDataPoint = graphData.dataPoints.first else { return }
        
        func generateLinePath(index index: Int = 0, xPosition: CGFloat = 0, yPosition: CGFloat) {
            let touchCirclePath = UIBezierPath(arcCenter: CGPoint(x: xPosition, y: yPosition), radius: CGFloat(30), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: xPosition, y: yPosition), radius: CGFloat(6), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            
            layer.insertSublayer(generateShapeLayer(touchCirclePath, position: CGPoint(x: xPosition, y: yPosition),graphPlotDataPoint: graphData.dataPoints[index], colorType: .Custom(color: UIColor.clearColor(), description: ""), nameCircle: false), atIndex: 1000)
            layer.insertSublayer(generateShapeLayer(circlePath, position: CGPoint(x: xPosition, y: yPosition),graphPlotDataPoint: graphData.dataPoints[index], colorType: colorModifiers?[index], nameCircle: true), atIndex: 1000)
            
            if index != graphData.dataPoints.count - 1 {
                let linePath = UIBezierPath()
                
                let xPositionNext = CGFloat((index + 1) * SankhyaGraph.horizontalItemWidth)
                let yPositionNext = SankhyaGraph.graphHeight - ((GraphDataUtil.multiplier(graphData.dataPoints) * CGFloat(graphData.dataPoints[index + 1].yAxis)))
                
                linePath.moveToPoint(CGPoint(x: xPosition, y: yPosition))
                linePath.addLineToPoint(CGPoint(x: xPositionNext, y: yPositionNext))
                
                layer.insertSublayer(generateLineLayerForPath(linePath, lineType: .Solid, colorType: colorModifiers?[index]), atIndex: 0)
                
                generateLinePath(index: index + 1, xPosition: xPositionNext, yPosition: yPositionNext)
            }
        }
        
        clearAllLines()
        
        let yPosition = SankhyaGraph.graphHeight - ((GraphDataUtil.multiplier(graphData.dataPoints) * CGFloat(firstDataPoint.yAxis)))
        
        generateLinePath(yPosition: yPosition)
    }
    
    private func setGraphSize() {
        let graphSize = CGFloat(graphData.dataPoints.count * SankhyaGraph.horizontalItemWidth)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setDimensionConstraint(.Width, constant: graphSize)
        
        if heightConstraint != nil { removeConstraints([heightConstraint!]) }
        
        heightConstraint = setDimensionConstraint(.Height, constant: SankhyaGraph.graphHeight)
    }
    
    private func generateShapeLayer(circlePath: UIBezierPath, position: CGPoint, graphPlotDataPoint: GraphPlotData, colorType: ColorType?, nameCircle: Bool) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circlePath.CGPath
        shapeLayer.name = circleLayerName
        
        shapeLayer.setValue(graphPlotDataPoint.xAxis, forKey: keyForXValue)
        shapeLayer.setValue(graphPlotDataPoint.yAxis, forKey: keyForYValue)
        
        shapeLayer.setValue(position.x, forKey: keyForXPosition)
        shapeLayer.setValue(position.y, forKey: keyForYPosition)
        
        shapeLayer.fillColor = colorType?.color?.CGColor ?? SankhyaGraph.graphDotColor
        shapeLayer.strokeColor = colorType?.color?.CGColor ?? SankhyaGraph.graphDotColor
        
        shapeLayer.lineWidth = 1
        
        return shapeLayer
    }
    
    private func generateLineLayerForPath(linePath: UIBezierPath, lineType: LineType, colorType: ColorType? = nil) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        
        lineLayer.path = linePath.CGPath
        
        lineType.applyStyle(lineLayer, color: colorType?.color?.CGColor ?? SankhyaGraph.graphLineColor)
        
        return lineLayer
    }
    
    private func addLinesToTouchLocation(touchLocation: CGPoint) {
        let dashedLinePath = UIBezierPath()
        
        dashedLinePath.moveToPoint(CGPoint(x: frame.minX, y: touchLocation.y))
        dashedLinePath.addLineToPoint(touchLocation)
        dashedLinePath.addLineToPoint(CGPoint(x: touchLocation.x, y: frame.maxY))
        
        layer.insertSublayer(generateLineLayerForPath(dashedLinePath, lineType: .Dashed), atIndex: 10)
    }
    
    private func clearAllLines() {
        clearDashedLines()
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
    }
    
    private func clearDashedLines() {
        subviews.filter({ $0 as? HoverView != nil }).forEach({ $0.removeFromSuperview() })
        layer.sublayers?.filter({ $0.name == LineType.dashedLineName }).forEach({ $0.removeFromSuperlayer() })
    }
}

extension GraphView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clearDashedLines()
        
        guard let touchLocation = touches.first?.locationInView(self), sublayer = layer.sublayers?.flatMap({ $0 as? CAShapeLayer }).findFirst({ $0.name == self.circleLayerName && CGPathContainsPoint($0.path, nil, touchLocation, true) }), let xPosition = sublayer.valueForKey(keyForXPosition) as? CGFloat, let yPosition = sublayer.valueForKey(keyForYPosition) as? CGFloat else { return }
        
        let point = CGPointMake(xPosition, yPosition)
        let hoverView = HoverView(frame: CGRectMake(point.x + 10, point.y - 10, 100, 20))
        
        if let xValue = sublayer.valueForKey(keyForXValue) as? NSDate, yValue = sublayer.valueForKey(keyForYValue) as? Double {
            hoverView.setTextOnHoverLabel("\(xValue.hour()) \(xValue.period().lowercaseString), \(String(format: "%.0f", yValue)) \(graphData.units ?? "")")
        }
        
        addSubview(hoverView)
        
        addLinesToTouchLocation(point)
    }
}