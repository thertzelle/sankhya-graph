# Sankhya Graph (సంఖ్య Graph)

Sankhya Graph is a graph framework that currently allows to chart one or more line graphs in a scroll view. This allows you to specify an XAxis and YAxis array of data to plot data to a line graph.

Additionally, Sankhya Graph allows you to draw vertical bars to highlight a section of data, as well as change the color of line segements that have been applied to the graph.

Sankhya Graphs are UIDesignable and allow you to quickly modify colors and presentation within UIStoryboard attributes inspector within XCode.

### Contributions

All Contributions are welcome.

### TODO

   *   Convert Project into a Swift Framework that can easily be pulled down and used.
   *   Tests (UI and Unit) need to be created.

### Version
0.1.0

### Usage
See SankhyaGraphExampleViewController.Swift for an example usage, but here is the jist:

   1. Add a UIView to your UIViewController / Storyboard / NIB
   2. Set it's class to SankhyaGraph
   3. Setup an IBOutlet and link it together.
   4. Provide Data by calling method `buildGraph`
   
Example Build Graph Function with Variety of Styles:

```swift
sankhyaGraph.buildGraph(graphData: numberOfGraphsRange.reduce([], combine: { (graphData, _) -> [GraphData] in graphData + [buildMockGraphData()] }))

        numberOfGraphsRange.forEach({ sankhyaGraph.applyStyleForData(colorModifiers: ColorType.randomType(24), graphIndex: $0) })
        
        sankhyaGraph.verticalBandAtPosition(.Color(color: UIColor.defaultVerticalBandColor(), description: "Flood Warning"), ranges: [(startIndex: 0, endIndex: 2), (startIndex: 5, endIndex: 6)])
        sankhyaGraph.verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 2, endIndex: 5)], graphIndex: 1)
        sankhyaGraph.verticalBandAtPosition(.Image(image: UIImage(named: "stripe") ?? UIImage(), description: "Drying Time"), ranges: [(startIndex: 6, endIndex: 8)], graphIndex: 2)

```

### The MIT License (MIT)
Copyright © `2016`

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
