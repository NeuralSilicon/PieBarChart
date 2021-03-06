
// MIT License
//
// Copyright (c) 2021 Ian Cooper
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import UIKit

public enum Chart{
    case Pie
    case Bar
    case Both
}

public class PieBarChart:UIView{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initPage(){
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func addChart(chart:Chart, data:ChartData, orientation:Orientation = .Vertical){
        ///remove all the subviews if any exist
        for views in self.subviews{
            views.removeFromSuperview()
        }
        
        switch chart {
        case .Bar:
            let barChart = BarChart(frame: self.bounds)
            self.addSubview(barChart)
            barChart.configData(chartData: data)
        case .Pie:
            let pieChart = PieChart(frame: self.bounds)
            self.addSubview(pieChart)
            pieChart.configPieChart(with: data, orientation: orientation)
        case .Both:
            let height = self.bounds.height/2
            
            let pieChart = PieChart(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: height))
            self.addSubview(pieChart)
            pieChart.configPieChart(with: data, orientation: orientation)
            
            let barChart = BarChart(frame: CGRect(x: 0, y: height, width: self.bounds.width, height: height))
            self.addSubview(barChart)
            barChart.configData(chartData: data)
            pieChart.delegate = barChart
        }
        
    }
    
}
