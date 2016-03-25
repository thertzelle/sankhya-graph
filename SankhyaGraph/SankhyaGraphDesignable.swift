import UIKit

public enum ColorType {
    case Standard
    case Custom(color: UIColor, description: String)
    
    var color: UIColor? {
        get {
            switch self {
            case .Standard: return nil
            case .Custom(let color, _): return color
            }
        }
    }
    
    var description: String? {
        get {
            switch self {
            case .Custom(_, let description): return description
            default: return nil
            }
        }
    }
    
    func toFillPattern() -> FillPattern? {
        switch self {
        case .Custom(let color, let description): return .Color(color: color, description: description)
        default: return nil
        }
    }
}

public enum FillPattern {
    case Color(color: UIColor, description: String)
    case Image(image: UIImage, description: String)
    
    var color: UIColor {
        get {
            switch self {
            case .Color(let color, _): return color
            case .Image(let image, _): return UIColor(patternImage: image)
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Color(_, let description): return description
            case .Image(_, let description): return description
            }
        }
    }
}

public typealias GraphPlotData = (xAxis: NSDate, yAxis: Double)
public typealias GraphRange = (startIndex: Int, endIndex: Int)
public typealias GraphData = (dataPoints: [GraphPlotData], units: String?, image: UIImage?)

public class SankhyaGraphDesignable: UIView {
    @IBInspectable
    var dashedLineColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.dashedLineColor = dashedLineColor }
    }
    
    @IBInspectable
    var graphHeight: CGFloat = 200 {
        didSet { SankhyaGraph.graphHeight = graphHeight }
    }
    
    @IBInspectable
    var graphLineColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.graphLineColor = graphLineColor.CGColor }
    }
    
    @IBInspectable
    var graphDotColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.graphDotColor = graphDotColor.CGColor }
    }
    
    @IBInspectable
    var graphAccentColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.graphAccentColor = graphAccentColor }
    }
    
    @IBInspectable
    var graphScrollViewBackgroundColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.graphScrollViewBackgroundColor = graphScrollViewBackgroundColor }
    }
    
    @IBInspectable
    var horizontalItemWidth: Int = 71 {
        didSet { SankhyaGraph.horizontalItemWidth = horizontalItemWidth }
    }
    
    @IBInspectable
    var hoverViewFillColor: UIColor = UIColor.lightGrayColor() {
        didSet { SankhyaGraph.hoverViewFillColor = hoverViewFillColor }
    }
    
    @IBInspectable
    var hoverViewStrokeColor: UIColor = UIColor.darkGrayColor() {
        didSet { SankhyaGraph.hoverViewStrokeColor = hoverViewStrokeColor }
    }
    
    static var graphHeight: CGFloat = 200
    static var horizontalItemWidth = 71
    static var numberOfIntervals = 10
    static var graphLineColor = UIColor.grayVariantCGColor()
    static var graphDotColor = UIColor.grayVariantCGColor()
    static var graphAccentColor = UIColor.lightGrayColor()
    static var graphScrollViewBackgroundColor = UIColor.whiteColor()
    static var dashedLineColor = UIColor.defaultAluminum()
    static var hoverViewFillColor = UIColor.defaultAluminum()
    static var hoverViewStrokeColor = UIColor.defaultDarkAluminum()
    static var imageSizeDimension: CGFloat = 25
    static var verticalAxisScrollViewWidth: CGFloat = 30
}

// MARK : - Test data for InterfaceBuilder (IBDesignable)

extension SankhyaGraph {
    override public func prepareForInterfaceBuilder() {
        let numberOfGraphsRange = 0...3
        
        buildGraph(graphData: numberOfGraphsRange.reduce([], combine: { (graphData, _) -> [GraphData] in graphData + [buildMockGraphData()] }))
        
        numberOfGraphsRange.forEach({ applyStyleForData(colorModifiers: ColorType.randomType(24), graphIndex: $0) })
        
        verticalBandAtPosition(.Color(color: UIColor.defaultVerticalBandColor(), description: "Flood Warning"), ranges: [(startIndex: 0, endIndex: 2), (startIndex: 5, endIndex: 6)])
        verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 2, endIndex: 5)], graphIndex: 1)
        verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 6, endIndex: 8)], graphIndex: 2)
    }
    
    private func buildMockGraphData() -> GraphData {
        let graphPlotData =  NSDate().datesForNextHours(24).reduce([], combine: { $0 + [(xAxis: $1, yAxis: Double(arc4random_uniform(100)) + 0.25 )] })
        return (graphPlotData, units: "mph", image: UIImage())
    }
}

extension ColorType {
    static func randomType(number: Int) -> [ColorType] {
        return (1...number).reduce([], combine: { (colorTypes,_) -> [ColorType] in
            Int(arc4random_uniform(2)) == 0 ? colorTypes + [.Standard] : colorTypes + [.Custom(color: UIColor.redColor(), description: "Heavy Rain")]
        })
    }
}