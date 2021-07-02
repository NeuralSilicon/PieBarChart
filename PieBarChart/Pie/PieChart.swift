
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

///pieChart and scrollView orientation
public enum Orientation{
    case Vertical
    case Horizontal
}

struct PiChartUI{
    ///arc degrees for each data
    var degrees:[CGFloat]
    {
        willSet{ //will set the count for our arrays
            self.count = newValue.count
        }
    }
    ///labels for each data
    var labels:[UILabel]
    ///arc degrees in radians
    var angles:[CGFloat]
    ///calayers for each data
    var layers:[CALayer]
    ///data count
    var count:Int
    
    ///hold the stackViews inside scrollView
    var stacks:[UIStackView]
    ///views inside each Stack
    var stackViews:[UIView]
    ///views in stack count for vertical scrollView
    var stackCount:Int
    
    init() {
        degrees=[];labels=[];angles=[];layers=[];count=0;stacks=[];stackViews=[];stackCount=0
    }

    mutating func append(label: UILabel,angle: CGFloat, layer:CALayer){
        self.labels.append(label);self.angles.append(angle);self.layers.append(layer)
    }
    
    func ui(for index:Int) -> (degree:CGFloat,label: UILabel,angle: CGFloat, layer:CALayer)?{
        guard index < count && index >= 0 else {return nil}
        return (degrees[index], labels[index], angles[index], layers[index])
    }
    
    public subscript(position: Int)-> (degree:CGFloat,label: UILabel,angle: CGFloat, layer:CALayer)?{
        guard position < count && position >= 0 else {return nil}
        return (degrees[position], labels[position], angles[position], layers[position])
    }
    
    public func stack(for index:Int) -> UIStackView?{
        guard index >= 0 else {return nil}
        return stacks[abs(index / 2)]
    }
    
    public func stack(Hfor index:Int) -> UIStackView?{
        guard index >= 0 else {return nil}
        return stacks[abs(index / stackCount)]
    }
}

class PieChart: UIView {
    ///our chart information
    var chartData:ChartData = ChartData()
    ///our ui structure
    var pieChartUI:PiChartUI = PiChartUI()
    ///last angle rotation - when selected, pie needs to know where the original position was
    private var lastRotation:CGFloat = 0.0
    ///scrollview to hold chart information
    var scrollView:UIScrollView = UIScrollView()
    ///selected Index for scrollView
    var prevStackViewIndex:Int = -1
    ///our raduis
    var radius:CGFloat = 0.0
    
    ///pichartView
    var pieChart:UIView = UIView()
    

    var orientation:Orientation = .Vertical
    
    weak var delegate:PieBarChartDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        ///if we have any layers added, remove them before we show the chart
        guard var sublayers = superview?.layer.sublayers else {
            return
        }
        sublayers.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Init our pieChart
    public func configPieChart(with chartData: ChartData, orientation: Orientation){
        ///remove all the subviews if any exist
        for views in self.subviews{
            views.removeFromSuperview()
        }
            
        ///set the orientation in which our chart and scrollView will be set
        self.orientation = orientation
        let rect = orientation == .Vertical ?
            ///12 padding - 4 top - 4 bottom - 4 between scrollView and piChart
            CGRect(x: 0, y: 0, width: self.frame.width - 8, height: (self.frame.height / 2) - 12)
            :
            CGRect(x: 0, y: 0, width: (self.frame.width / 2) - 12, height: self.frame.height - 8)
        /*
         config our view
         set the radius in which we will use to calculate labels positions
         based on the angle of each data inside the circle and creates the corner radius for
         our path
         */
        
        self.radius = rect.width > rect.height ? rect.height / 2 : rect.width / 2
        
        pieChart.backgroundColor = .clear
        pieChart.layer.cornerRadius = radius
        pieChart.translatesAutoresizingMaskIntoConstraints = false

        
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        
        self.addSubview(pieChart)
        self.addSubview(scrollView)
      
        ///set contrainsts for our piechart and scrollView
        if orientation == .Vertical{
            NSLayoutConstraint.activate([
                pieChart.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                pieChart.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                pieChart.heightAnchor.constraint(equalToConstant: radius*2),
                pieChart.widthAnchor.constraint(equalToConstant: radius*2),
                
                scrollView.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 4),
                scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                scrollView.heightAnchor.constraint(equalToConstant: rect.height),
                scrollView.widthAnchor.constraint(equalToConstant: rect.width)
            ])
        }else{
            NSLayoutConstraint.activate([
                pieChart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
                pieChart.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                pieChart.heightAnchor.constraint(equalToConstant: radius*2),
                pieChart.widthAnchor.constraint(equalToConstant: radius*2),
                
                scrollView.leadingAnchor.constraint(equalTo: pieChart.trailingAnchor, constant: 4),
                scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
                scrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                scrollView.heightAnchor.constraint(equalToConstant: rect.height),
                scrollView.widthAnchor.constraint(equalToConstant: rect.width),
            ])
        }
       
        self.layoutIfNeeded()

        //.if empty do not continue
        guard chartData.count > 0 else {return}
        self.chartData = chartData
        
        /*
         find the total Entry of all entries
         convert the entry to percentage by entry divide by total entry
         and multiply by 360 to find the degree for each entry
         */
        let totalEntry:Double = self.totalEntries(for: chartData.data)
        chartData.data.forEach({ (entry) in
            self.pieChartUI.degrees.append(CGFloat((entry / totalEntry) * 360))
          
        })
        let center = pieChart.center.x > pieChart.center.y ? pieChart.center.y : pieChart.center.x
        ///create a circular path
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: center - 4, y: center - 4),
                                      radius: radius / 1.4,
                                      startAngle: 0,
                                      endAngle: 2 * CGFloat.pi,
                                      clockwise: true)//UIBezierPath(ovalIn: pieChart.bounds)
   
        ///hold value for total data arc degree , to add up to the next degree to know the position where the arc ends
        var totalDegree:CGFloat = 0
        ///iterate value
        var i:Int = 0
        ///our total degree to the point but without the 360 based
        var totalDegrees:CGFloat = 0
        
        ///calculate Label font size and size
        let fontSize:CGFloat = self.pieChart.frame.width < 200 ? 10:12 //8 : 10
        
        
        pieChartUI.degrees.forEach { (degree) in
            ///gives back (name, data, color) for this index
            guard let entry = chartData.entry(for: i) else {return}

            ///find the arc degree based on the circle
            let arcDegree = (degree) / 360
            
            ///create a shape
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath

            circleLayer.strokeStart = totalDegree
            ///add the arc degree to current to know where it ends
            circleLayer.strokeEnd = totalDegree + arcDegree
           
            circleLayer.lineWidth = radius * 0.5
            circleLayer.strokeColor = entry.color.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
   
            ///add shadow to our layer but set opacity to zero
            shadow(for: circleLayer)
            
            ///create a fade version of our circle but wider toward the center
            let circleLayerFade = CAShapeLayer()
            circleLayerFade.path = circlePath.cgPath
            
            circleLayerFade.strokeStart = totalDegree
            circleLayerFade.strokeEnd = totalDegree + arcDegree
                        
            circleLayerFade.lineWidth = radius * 0.6// radius*1.2
            circleLayerFade.strokeColor = entry.color.withAlphaComponent(0.5).cgColor
            circleLayerFade.fillColor = UIColor.clear.cgColor
      
            ///animate the stroke end
            let animcolor = CABasicAnimation(keyPath: "strokeEnd")
            animcolor.fromValue = totalDegree
            animcolor.toValue = totalDegree + arcDegree
            animcolor.duration = 0.6
            animcolor.repeatCount = 0
            animcolor.autoreverses = false
            circleLayer.add(animcolor, forKey: "strokeEnd")
            
            /*
             convert arc degree to radians to find the position in unit circle plane
             by dividing the degree to 2, will yeild the center of the arc and adding
             total arch degrees to know exact position from 0
             */
            let angle = (((degree * 0.5) + totalDegrees )).deg2rad
            let labelSize:CGSize = CGSize(
                width: radius / 3,
                height: (radius / 3))
            let label = UILabel()
            label.frame.size = labelSize
            label.frame.origin = point(angle: angle, radius: radius / 1.3, reduction: labelSize)
            label.text = String(describing: Double((degree / 360) * 100).rounded(toPlaces: 1)) + "%"
            label.textAlignment = .center
            label.textColor = UIColor.systemBackground
            label.font = UIFont.customFont(type: .AppleSDGothicNeo_Bold, size: fontSize)
            label.isUserInteractionEnabled = true
            label.backgroundColor = .clear
            ///rotate our label to adjust with the arc degree by looking at the unit circle
            label.transform = CGAffineTransform(rotationAngle: (angle > .pi/2 && angle < 3 * .pi/2) ? angle - .pi : angle)
            
            ///add tap gesture to our lable with passing the index as name of our tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(_:)))
            tap.name = "\(i)"
            label.addGestureRecognizer(tap)
            
            ///add our layers to the view
            pieChart.layer.addSublayer(circleLayerFade)
            pieChart.layer.addSublayer(circleLayer)
            
            ///if our arc degree is less than 8 then remove the label since it can't be fit inside that arc
            if degree < 8 {
                label.text = " "
            }
            
            pieChart.addSubview(label)
            
            ///append our UI objects
            pieChartUI.append(label: label, angle: angle, layer: circleLayer)
            
            ///total degree without handling 360  - not in radians
            totalDegrees += degree
            ///total degree with hanlding 360 - not in radians
            totalDegree += arcDegree
            ///increase the index
            i+=1
            
        } ///end of degrees loop

        
        ///config our scrollView
        if orientation == .Vertical{
            configScrollViewVertical()
        }else{
            configScrollViewHorizontal()
        }
    }
  
    //MARK: - handle our tap gesture
    @objc private func tappedLabel(_ sender:UITapGestureRecognizer){
        ///check certain conditions before we pass the index
        guard let index = Int(sender.name ?? "-1"), index >= 0 && index < pieChartUI.count
              , let ui = pieChartUI.ui(for: index)
              else {return}
        ///scroll to the stack that holds the view and label for our index
        scroll(to: index)
        ///show the shadow opacity with animation for our selected layer
        showShadow(for: ui.layer,index: index)
        ///rotate the circle so the label would be in correct form and legible to the user
        rotate(with: ui.angle , index:index)
    }
    
    
    ///find the exact point in plane based on unit circle
    private func point(angle: CGFloat, radius:CGFloat, reduction:CGSize) -> CGPoint {
        let center = self.pieChart.center.x > self.pieChart.center.y ?
        self.pieChart.center.y : self.pieChart.center.x
        /// angle of the arc center - and raduis of the circle  + the distance from center of our circle
        let x = center + (cos(angle) * radius)
        let y = center + (sin(angle) * radius)
        ///25 is the half the size of our label
        
        var quadrantY:CGFloat = 0.0
        var quadrantX:CGFloat = 0.0
        
        ///first quadrant - negative angle would turn it back to 0
        if (angle > 0 && angle <= .pi / 2){
            quadrantY = -.pi
            quadrantX = -.pi

        ///second quadrant - .pi - angle would turn it toward 180
        }else if (angle >= .pi / 2 && angle < .pi){
            quadrantY = -angle
            quadrantX = -angle
            
        ///third quadrant - .pi - angle would turn it back to 180
        }else if (angle > .pi && angle <= 3 * .pi / 2){
            quadrantY = -angle/2
            quadrantX = -angle
            
        ///fourth quadrant - 2 * .pi - angle would turn it toward 2.pi or 0
        }else if (angle >= 3 * .pi / 2 && angle < 2 * .pi){
            quadrantY = -angle/2
            quadrantX = -angle
        }
        
        return CGPoint(x: x - (reduction.width / 2) + quadrantX, y: y - (reduction.height / 2) + quadrantY)
    }
    
    ///calculate the total data additions - to find the correct percent
    private func totalEntries(for entries:[Double]) -> Double{
        var totalEntries:Double = 0
        entries.forEach { (entry) in
            totalEntries+=entry
        }
        return totalEntries
    }
    
    ///handle circlular rotation based on angle of the arc and index
    private func rotate(with angle:CGFloat , index:Int){
        DispatchQueue.main.async {
            ///rotation angle
            var rotateAngle:CGFloat = 0.0
    
            ///first quadrant - negative angle would turn it back to 0
            if (angle > 0 && angle <= .pi / 2){
                rotateAngle = -angle
                
                /*
                 first quadrant should be positve since if our arc is in first
                 quadrant we rotate back to 0, therefore the original value bigger than 0
                 */
                if self.lastRotation != 0{
                    self.lastRotation = abs(rotateAngle)
                }
                
            ///second quadrant - .pi - angle would turn it toward 180
            }else if (angle >= .pi / 2 && angle < .pi){
                rotateAngle = .pi - angle
                
                /*
                 second quadrant should be negative since if our arc is in second
                 quadrant we rotate to .pi, therefore the original value less than .pi
                */
                if self.lastRotation != 0{
                    self.lastRotation = -(rotateAngle)
                }
                
            ///third quadrant - .pi - angle would turn it back to 180
            }else if (angle > .pi && angle <= 3 * .pi / 2){
                rotateAngle = .pi - angle
                
                /*
                 third quadrant should be positive since if our arc is in third quadrant
                 we rotate to .pi, therefore original value was bigger than .pi
                 */
                if self.lastRotation != 0{
                    self.lastRotation = abs(rotateAngle)
                }
                
            ///fourth quadrant - 2 * .pi - angle would turn it toward 2.pi or 0
            }else if (angle >= 3 * .pi / 2 && angle < 2 * .pi){
                rotateAngle = (2 * .pi) - angle
                
                /*
                 fourth quadrant should be negative since if our arc is in fourth quadrant
                 we rotate to 2*.pi, therefore original value was less than 2*.pi
                 */
                if self.lastRotation != 0{
                    self.lastRotation = -(rotateAngle)
                }
                
            }

            ///adjust the rotation angle based on the original circle angle
            rotateAngle += self.lastRotation
            
            ///animate the rotation
            UIView.animate(withDuration: 1.0
                           , delay: 0.0
                           , usingSpringWithDamping: 0.6
                           , initialSpringVelocity: 0
                           , options: [ .curveEaseInOut]
                           , animations: {
                            
                            self.pieChart.transform = CGAffineTransform(rotationAngle: rotateAngle)
                            
            }, completion: { _ in
                
                ///set shadow opacity to zero
                self.removeShadow(for: self.pieChartUI.layers[index], index: index)
            })
            
        } ///end of dispatchQueue
    }
    
    //MARK: - Shadows
    private func shadow(for layer:CALayer){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 5, height: 10)
        layer.shadowOpacity = 0.0
    }
    
    
    private var originalTransform:CATransform3D!
    private var originalLabelTransform:CATransform3D!
    private func showShadow(for layer:CALayer, index:Int){
        layer.shadowOpacity = 0.5
        let animator  = CABasicAnimation(keyPath: "shadowOpacity")
        animator.fromValue = 0.0
        animator.toValue = 0.5
        animator.duration = 0.5
        animator.autoreverses = false
        animator.repeatCount = 0
        layer.add(animator, forKey: "shadowOpacity")
        
        originalTransform = layer.transform
        layer.transform = CATransform3DMakeTranslation(5, 5, 5)
        
        originalLabelTransform = pieChartUI.labels[index].layer.transform

        var trans = CATransform3DMakeTranslation(5, 5, 5)
        trans = CATransform3DScale(trans, 1.5, 1.5, 0)
        pieChartUI.labels[index].layer.transform = trans
    }
    
    private func removeShadow(for layer:CALayer, index:Int){
        layer.shadowOpacity = 0.0
        let animator  = CABasicAnimation(keyPath: "shadowOpacity")
        animator.fromValue = 0.5
        animator.toValue = 0.0
        animator.duration = 0.5
        animator.autoreverses = false
        animator.repeatCount = 0
        layer.add(animator, forKey: "shadowOpacity")
        
        layer.transform = originalTransform
        
        pieChartUI.labels[index].layer.transform = originalLabelTransform
    }
}

///convert degree to radians
extension CGFloat{
    var deg2rad:CGFloat {
        return self * .pi / 180
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
