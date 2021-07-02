
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

extension BarChart{
    
    public func configData(chartData:ChartData){

        ///remove all the subviews if any exist
        for views in self.subviews{
            views.removeFromSuperview()
        }
        
        ///if empty do not continue
        guard chartData.count > 0 else { print("No Data at barchart"); return }

        /*
         config our scrollview
         our  data entries and create labels and views
         based on the amount of data we have
         */
        self.backgroundColor = .clear
        self.delegate = self
        self.isScrollEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        /*
         set our scrollView contentSize -> data count * width of each view * 16
         distance between each view 8 left and 8 right side
         */
        let count = chartData.count
   
        self.contentSize.width = CGFloat((count * Int(width)) + (16*count) - 8)

        /*
         frame height - default height - 8 which is 8 top padding for each
         label which gives us the height available for our bar divided by
         the max entries in our data, ex: 80 is max, then maxBar gives back 100
         */
        let frameHeight = (self.frame.height - height - 8) / maxBar(max: chartData.data.max() ?? 0)
    
        ///add our labels and views
        for (i, j) in chartData.names.enumerated(){
            guard let entry = chartData.entry(for: i) else {print("Couldn't iterate through ChartData");return}

            /*
             view - bar
             viewHeight is the entrie * frameheight which is the max percentage we have
             view x is i * 16 which gives back the distance from 0 to the current view since
             each view has 8 left and 8 right padding, + i * the width of our view y is scroll height
             - view Height - default height for labels - 8 padding
             */
            let viewHeight = CGFloat(entry.data)*(frameHeight)
            let view = UIView(frame: CGRect(x: CGFloat((i*16)+(i*Int(width)))
                                            , y: self.frame.height - viewHeight - height - 8
                                            , width: width
                                            , height: viewHeight))
            view.backgroundColor = .clear
            view.layer.cornerRadius = 5
            //initially move our view down and alpha to 0
            view.alpha = 0.0
            view.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            shadow(for: view)
            
            //adding gradient color to our bar
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.backgroundColor = UIColor.clear.cgColor
            gradient.colors = [entry.color.cgColor as Any, UIColor.clear.cgColor]
            gradient.locations = [0.0,1.0]
            gradient.cornerRadius = 5
            view.layer.addSublayer(gradient)
            
            /*
             label - entries
             since we are rotating the label by - pi/2 then we have to divide the
             x by the width since it's rotation would be around the center of label
             */
            let label = UILabel(frame:CGRect(x: 0,
                                             y: 0
                                             , width: view.frame.height - 4
                                             , height: width ))
            label.text = "\(entry.data)"
            label.textAlignment = .left
            label.lineBreakMode = .byTruncatingTail
            label.numberOfLines = 1
            label.font = UIFont.customFont(type: .AppleSDGothicNeo_Medium, size: 13)
            label.transform = CGAffineTransform(rotationAngle: -.pi/2)
            label.frame.origin = CGPoint(x: 0, y: -4)
            label.backgroundColor = .clear
            
            //if we have data less than 30 height then don'nt show the info
            if view.frame.height > 30{
                view.addSubview(label)
            }
            
            //label - name
            let labelTitle = UILabel(frame:CGRect(x: CGFloat((i*16)+(i*Int(width)))
                                                  , y: self.frame.height - height - 16
                                                  , width: width
                                                  , height: height))
            labelTitle.text = j
            labelTitle.textAlignment = .center
            labelTitle.lineBreakMode = .byTruncatingTail
            labelTitle.numberOfLines = 1
            labelTitle.font = UIFont.customFont(type: .AppleSDGothicNeo_Bold, size: 13)
            
            self.views.append(view)
            self.addSubview(labelTitle)
            self.addSubview(view)
        }

        /*
         loop through our views and show the ones that are on
         the screen with animation, 0..<to our scrollview width if
         it contains the view.x value, then can be shown
         */
        for (i,view) in views.enumerated(){
            if (0..<self.bounds.width).contains(view.frame.origin.x){
                UIView.animate(withDuration: 1.5
                               , delay: TimeInterval(Double(i)*0.15)
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                view.transform = .identity
                                view.alpha = 1.0
                }, completion: nil)
            }
        }

        /*
         label - 100 percent value
         showing our maxBar value that we found before to showcase our
         view percentage
         */
        let label = UILabel(frame:CGRect(x: 4,
                                         y: 0
                                         , width: 80
                                         , height: 40 ))
        label.textColor = UIColor.darkGray
        label.text = "\(maxBar(max: chartData.data.max() ?? 0))"
        label.textAlignment = .left
        label.font = UIFont.customFont(type: .AppleSDGothicNeo_Light, size: 14)
        self.addSubview(label)
      
        //50 percent
        drawDottedLine(start: CGPoint(x: 0, y: (self.frame.height - self.height - 8) / 2), end: CGPoint(x: self.contentSize.width*1.5, y: (self.frame.height - self.height - 8) / 2))
        
        //100 percent
        drawDottedLine(start: CGPoint(x: 0, y: 0), end: CGPoint(x: self.contentSize.width*1.5, y: 0))
    }
    
    //add dashed lines
    private func drawDottedLine(start p0: CGPoint, end p1: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.8
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    //give back the maxBar value
     private func maxBar(max:Double) -> CGFloat{
        let str = String(describing: Int(max))
        var output = "1"
        for _ in 0..<str.count{
            output.append("0")
        }
        return CGFloat(Int(output) ?? 0)
    }
    
    
    private func shadow(for view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.shadowOpacity = 0.0
    }
}
