import Foundation
import SwiftUI
import PieBarChart

public class PieBarChartCoordinator: NSObject, PieBarChartDelegate {
    
    var barChartWasSelected: (_ index: Int) -> Void
    
    init(barChartSelected: @escaping (_ index: Int) -> Void) {
        barChartWasSelected = barChartSelected
    }
    
    public func barChar(for index: Int) {
        barChartWasSelected(index)
    }
}

final class PieBarChartViewController: UIViewController {
    
    
    var delegate: PieBarChartCoordinator? = nil
    var piebarChart: PieBarChart = PieBarChart()
    @Binding var chartData: ChartData
    
    required public init(chartData: Binding<ChartData>) {
        self._chartData = chartData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addsubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        piebarChart.addChart(chart: .Bar, data: self.chartData, orientation: .Vertical)
        
        
    }
    private func addsubviews(){
        self.view.addSubview(piebarChart)
        NSLayoutConstraint.activate([
            piebarChart.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            piebarChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            piebarChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            piebarChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    
}

struct PieBarChartView: UIViewControllerRepresentable {
    
    @Binding var chartData: ChartData
    
    var barChartWasSelected: (_ index: Int) -> Void
    
    init(chartData: Binding<ChartData>, barChartSelected: @escaping (_ index: Int) -> Void) {
        self._chartData = chartData
        self.barChartWasSelected = barChartSelected
    }
    
    func makeCoordinator() -> PieBarChartCoordinator {
        
        return(PieBarChartCoordinator(barChartSelected: barChartWasSelected))
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PieBarChartView>) -> PieBarChartViewController {
        
        let pieBarChartViewController = PieBarChartViewController(chartData: self.$chartData)
        pieBarChartViewController.delegate = context.coordinator
        return pieBarChartViewController
    }
    
    func updateUIViewController(_ uiViewController: PieBarChartViewController, context: UIViewControllerRepresentableContext<PieBarChartView>) {
        uiViewController.piebarChart.addChart(chart: .Bar, data: self.chartData, orientation: .Vertical)
    }
    
}

struct PieBarChartView_Previews: PreviewProvider {
    
    private static func randomData() -> String{
        let pswdChars = Array("123456789")
        return String((0..<3).compactMap({ _ in pswdChars.randomElement()}))
    }
    
    //random colors for each bar
    private static func randomColor() -> UIColor{
        return [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPink, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemOrange, UIColor.systemIndigo].randomElement()!
    }
    
    static var previews: some View {
        
        var chartData: ChartData = ChartData()
        chartData.names = ["USA","Iran","Italy","Germany","South Africa","Japan","UK","Afghanistan","France"].sorted()
        
        for _ in 0..<chartData.count{
            chartData.data.append(Double(randomData())!)
            chartData.colors.append(randomColor())
        }
        
        return
        
        PieBarChartView(chartData: .constant(chartData)) { index in
            print(index)
        }
        
        
    }
}
