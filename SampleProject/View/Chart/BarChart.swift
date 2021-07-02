

import UIKit
import PieBarChart

class BarChart: UIViewController {

    var piebarChart=PieBarChart()
    var chartData:ChartData = ChartData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addsubviews()
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reload the size
        self.view.layoutIfNeeded()
        // choose the chart and pass the data
        piebarChart.addChart(chart: .Bar, data: chartData)
    }
    
    
    private func addsubviews(){
        chartData.names = ["USA","Iran","Italy","Germany","South Africa","Japan","UK","Afghanistan","France","Malaysia","Australia","Dubai","Spain","Rome","Greece"].sorted()

        for _ in 0..<chartData.count{
            chartData.data.append(Double(randomData())!)
            chartData.colors.append(randomColor())
        }
        
        // add as subview and setup constraint
        self.view.addSubview(piebarChart)
        NSLayoutConstraint.activate([
            piebarChart.topAnchor.constraint(equalTo: view.topAnchor, constant: .topNavigConstant),
            piebarChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            piebarChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            piebarChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
    }
    
    // random numbers for data
    private func randomData() -> String{
        let pswdChars = Array("123456789")
        return String((0..<3).compactMap({ _ in pswdChars.randomElement()}))
    }

    //random colors for each bar
    private func randomColor() -> UIColor{
        return [UIColor.systemRed, UIColor.systemBlue, UIColor.systemPink, UIColor.systemTeal, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemOrange, UIColor.systemIndigo].randomElement()!
    }
}
