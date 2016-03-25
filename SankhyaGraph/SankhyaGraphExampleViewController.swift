import UIKit

class SankhyaGraphViewController: UIViewController {
    @IBOutlet weak var sankhyaGraph: SankhyaGraph!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfGraphsRange = 0...3

        sankhyaGraph.buildGraph(graphData: numberOfGraphsRange.reduce([], combine: { (graphData, _) -> [GraphData] in graphData + [buildMockGraphData()] }))

        numberOfGraphsRange.forEach({ sankhyaGraph.applyStyleForData(colorModifiers: ColorType.randomType(24), graphIndex: $0) })
        
        sankhyaGraph.verticalBandAtPosition(.Color(color: UIColor.defaultVerticalBandColor(), description: "Flood Warning"), ranges: [(startIndex: 0, endIndex: 2), (startIndex: 5, endIndex: 6)])
        sankhyaGraph.verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 2, endIndex: 5)], graphIndex: 1)
        sankhyaGraph.verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 6, endIndex: 8)], graphIndex: 2)
    }

    private func buildMockGraphData() -> GraphData {
        let graphPlotData =  NSDate().datesForNextHours(24).reduce([], combine: { $0 + [(xAxis: $1, yAxis: Double(arc4random_uniform(100)) + 0.25 )] })
        return (graphPlotData, units: "Rain", image: UIImage(named: "rain"))
    }
}