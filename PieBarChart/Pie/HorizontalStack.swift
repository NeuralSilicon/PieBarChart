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

extension PieChart{
    
    func configScrollViewHorizontal(){
        
        let count:Int = Int(scrollView.frame.height - ((scrollView.frame.height / 50)) )/50
        pieChartUI.stackCount = count
        
        
        var index:Int = 0
        var prevStack:UIStackView? = nil
     
        let through:CGFloat = (CGFloat(chartData.count) / CGFloat(count)).rounded(.up)

        for i in stride(from: 0, through: Int(through) - 1 , by: 1){
       
            let stackView:UIStackView = UIStackView()
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .equalSpacing
            stackView.spacing = 0
            stackView.alignment = .leading
            scrollView.addSubview(stackView)

            let leftOver = chartData.count - index
            let stackViewHeight:CGFloat = CGFloat(leftOver >= count ?
                                                    count * 50 : leftOver * 50)
           
            if prevStack == nil{
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4),
                    stackView.heightAnchor.constraint(equalToConstant: stackViewHeight),
                    stackView.widthAnchor.constraint(equalToConstant: scrollView.frame.width)
                ])
            }else{
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    stackView.heightAnchor.constraint(equalToConstant: stackViewHeight),
                    stackView.leadingAnchor.constraint(equalTo: prevStack!.trailingAnchor, constant: 0),
                    stackView.widthAnchor.constraint(equalToConstant: scrollView.frame.width )
                ])
            }
            
            if i == Int(through) - 1 || Int(through) - 1 == 0{
                NSLayoutConstraint.activate([
                    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0)
                ])
            }
            
            scrollView.layoutIfNeeded()
            
            for j in index...chartData.count - 1{
             
                if j == (i+1)*count{
                    index = j
                    break
                }
                guard let entry = chartData.entry(for: j) else {break}
                
                let viewHolder = UIView()
                viewHolder.backgroundColor = .clear
                viewHolder.translatesAutoresizingMaskIntoConstraints = false
                viewHolder.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
                viewHolder.heightAnchor.constraint(equalToConstant: 50).isActive = true
                stackView.addArrangedSubview(viewHolder)
                
                let View = UIView()
                viewHolder.addSubview(View)
                
                View.layer.cornerRadius = 5
                View.backgroundColor = entry.color
                View.translatesAutoresizingMaskIntoConstraints = false
                View.leftAnchor.constraint(equalTo: viewHolder.leftAnchor, constant: 0).isActive = true
                View.widthAnchor.constraint(equalToConstant: 35).isActive = true
                View.heightAnchor.constraint(equalToConstant: 35).isActive = true
                View.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor).isActive = true
                shadow(for: View)

                let Label = UILabel()
                viewHolder.addSubview(Label)
                
                Label.textAlignment = .left
                Label.numberOfLines = 0
                Label.lineBreakMode = .byWordWrapping
     
                Label.translatesAutoresizingMaskIntoConstraints = false
                Label.heightAnchor.constraint(equalToConstant: 50).isActive = true
                Label.leadingAnchor.constraint(equalTo: View.trailingAnchor, constant: 4).isActive = true
                Label.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor).isActive = true
                Label.trailingAnchor.constraint(equalTo: viewHolder.trailingAnchor, constant: 0).isActive = true
                
                let normalText = entry.name + ": "
                let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .light)]
                let attributedString = NSMutableAttributedString(string: normalText, attributes:attrs)

                let boldText = "\(entry.data)"
                
                let attr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .medium)]
                let normalString = NSMutableAttributedString(string: boldText, attributes:attr)

                attributedString.append(normalString)
                Label.attributedText = attributedString
                
                
                pieChartUI.stackViews.append(View)

                viewHolder.alpha = 0.0
                viewHolder.transform = CGAffineTransform(translationX: +scrollView.frame.width, y: 0)
                
            } ///end of j loop
            
            
            pieChartUI.stacks.append(stackView)
            prevStack = stackView
    
        } ///end of i loop

         
        for (i,stack) in pieChartUI.stacks.enumerated(){
            if (0...scrollView.bounds.width).contains(stack.frame.origin.x){
                for views in stack.arrangedSubviews{
                    UIView.animate(withDuration: 1.5
                                   , delay: TimeInterval(Double(i)*0.3)
                                   , usingSpringWithDamping: 0.8
                                   , initialSpringVelocity: 0
                                   , options: .allowUserInteraction
                                   , animations: {
                                    
                                    views.alpha = 1.0
                                    views.transform = .identity
                                    
                    }, completion: nil)
                } ///end of arrangedSubViews loop
            } // end of if loop
        } /// end of enumerated for loop
    }
    
    
    func horizontalScrolling(){
        let lastOffset = scrollView.contentOffset.x + scrollView.bounds.width
      
        for (_,stack) in pieChartUI.stacks.enumerated(){
            
            if (scrollView.contentOffset.x...lastOffset).contains(stack.frame.origin.x){
                for (i, views) in stack.arrangedSubviews.enumerated(){
                    UIView.animate(withDuration: 1.5
                                   , delay:TimeInterval(Double(i)*0.2)
                                   , usingSpringWithDamping: 0.8
                                   , initialSpringVelocity: 0
                                   , options: .allowUserInteraction
                                   , animations: {
                                    
                                    views.alpha = 1.0
                                    views.transform = .identity
                                    
                    }, completion: nil)
                } ///end of arrangedSubViews loop
            }else{
                for (i, views) in stack.arrangedSubviews.enumerated(){
                    UIView.animate(withDuration: 1.5
                                   , delay: TimeInterval(Double(i)*0.2)
                                   , usingSpringWithDamping: 0.8
                                   , initialSpringVelocity: 0
                                   , options: .allowUserInteraction
                                   , animations: {
                                    
                                    views.alpha = 0.0
                                    views.transform = CGAffineTransform(translationX: self.scrollView.frame.width, y: 0)
                                    
                    }, completion: nil)
                } ///end of arrangedSubViews loop
            }
        }
    }
}
