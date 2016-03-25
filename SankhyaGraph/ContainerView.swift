enum ContainerViewType {
    case Legend
    case Graph
    case VerticalAxis
    case HorizontalAxis
    
    static func allValues() -> [ContainerViewType] {
        return [.Legend, .Graph, .VerticalAxis, .HorizontalAxis]
    }
}

protocol ContainerView {
    func setConstraints(graphView: SankhyaGraph, graphPlotData: [GraphPlotData])
    func removeAllSubviews()
}