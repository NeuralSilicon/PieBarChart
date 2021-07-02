

import UIKit
import PieBarChart

class PieChart: UIViewController {

    var piebarChart=PieBarChart()
    var chartData:ChartData = ChartData()
    var orientation:Orientation = .Vertical

    var button:UIButton={
       let button = UIButton()
        button.setTitle("Change Orientation", for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addsubviews()
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reload the size
        self.view.layoutIfNeeded()
        // choose the chart and pass the data
        piebarChart.addChart(chart: .Pie, data: chartData, orientation: orientation)
    }
    
    private func addsubviews(){
        
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: .bottomConstant),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.addTarget(self, action: #selector(changeOrien), for: .touchUpInside)
        
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
            piebarChart.bottomAnchor.constraint(equalTo: button.topAnchor, constant: .bottomConstant)
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
    
    @objc private func changeOrien(){
        orientation = orientation == .Vertical ? .Horizontal : .Vertical
        piebarChart.addChart(chart: .Pie, data: chartData, orientation: orientation)
    }
}
