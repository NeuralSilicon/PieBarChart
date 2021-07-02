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
    
    func configScrollViewVertical(){
        
        var labelWidth:CGFloat = 0.0
        
        scrollView.contentSize.height = CGFloat((pieChartUI.count / 2) * 50 + (pieChartUI.count / 2) * 8)
        labelWidth = ((scrollView.frame.width - (4*8)) / 2 )

        
        var prevStack:UIStackView? = nil
        
        for i in stride(from: 0, through: pieChartUI.count - 1, by: 2){
            
            let stackView:UIStackView = UIStackView()
            stackView.axis = .horizontal
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .equalSpacing
            stackView.spacing = 8
            stackView.alignment = .leading
            scrollView.addSubview(stackView)

            if prevStack == nil{
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
                    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
                    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
                    stackView.heightAnchor.constraint(equalToConstant: 50),
                    stackView.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 16)
                ])
            }else{
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: prevStack!.bottomAnchor, constant: 8),
                    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
                    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
                    stackView.heightAnchor.constraint(equalToConstant: 50),
                    stackView.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 16)
                ])
            }
            
            
            if i == pieChartUI.count - 1 || i == pieChartUI.count - 2{
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
                
            }

            guard let entry = chartData.entry(for: i) else {break}
            
            let leftView = UIView()
            leftView.layer.cornerRadius = 5
            leftView.backgroundColor = entry.color
            leftView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            leftView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            shadow(for: leftView)

            let leftLabel = UILabel()
            leftLabel.textAlignment = .left
            leftLabel.backgroundColor = .clear
            leftLabel.numberOfLines = 0
            leftLabel.lineBreakMode = .byWordWrapping
            leftLabel.font = UIFont.customFont(type: .AppleSDGothicNeo_Light, size: 14)
            
            if i == pieChartUI.count - 1{
                leftLabel.widthAnchor.constraint(equalToConstant: labelWidth*2 - 8).isActive = true
            }else{
                leftLabel.widthAnchor.constraint(equalToConstant: labelWidth - 8).isActive = true
            }
            
            leftLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

            leftLabel.attributedText = partialBold(normalText: entry.name, boldText: "\n\(entry.data)")

            stackView.addArrangedSubview(leftView)
            stackView.addArrangedSubview(leftLabel)
            pieChartUI.stackViews.append(leftView)
            
            if let nextEntry = chartData.entry(for: i+1){
                
                let rightView = UIView()
                rightView.layer.cornerRadius = 5
                rightView.backgroundColor = nextEntry.color
                rightView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                rightView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                shadow(for: rightView)
    
                let rightLabel = UILabel()
                rightLabel.textAlignment = .left

                rightLabel.numberOfLines = 0
                rightLabel.lineBreakMode = .byWordWrapping
                rightLabel.font = UIFont.customFont(type: .AppleSDGothicNeo_Light, size: 14)
                rightLabel.widthAnchor.constraint(equalToConstant: labelWidth - 8).isActive = true
                rightLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

                rightLabel.attributedText = partialBold(normalText: nextEntry.name, boldText: "\n\(nextEntry.data)")
                
                stackView.addArrangedSubview(rightView)
                stackView.addArrangedSubview(rightLabel)
                pieChartUI.stackViews.append(rightView)
                
            }
            
            stackView.alpha = 0.0
            stackView.transform = CGAffineTransform(translationX: -scrollView.frame.width, y: 0)
            
            pieChartUI.stacks.append(stackView)

            prevStack = stackView
        }

         
        for (i,stack) in pieChartUI.stacks.enumerated(){
            if (0...scrollView.bounds.height).contains(stack.frame.origin.y){
                UIView.animate(withDuration: 1.0
                               , delay: TimeInterval(Double(i)*0.15)
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                
                                stack.transform = .identity
                                stack.alpha = 1.0
                                
                }, completion: nil)
            }
        }
    }
    
    func partialBold(normalText:String, boldText:String) -> NSAttributedString{
        let normalText = normalText + ":"
        let attrs = [NSAttributedString.Key.font : UIFont.customFont(type: .AppleSDGothicNeo_Light, size: 14)]
        let attributedString = NSMutableAttributedString(string: normalText, attributes:attrs)

        let boldText = boldText
        
        let attr = [NSAttributedString.Key.font : UIFont.customFont(type: .AppleSDGothicNeo_Medium, size: 14)]
        let normalString = NSMutableAttributedString(string: boldText, attributes:attr)

        attributedString.append(normalString)
        return attributedString
    }
    
    func verticalScrolling(){
        let lastOffset = scrollView.contentOffset.y + scrollView.bounds.height
        for (_,stack) in pieChartUI.stacks.enumerated(){
            
            if (scrollView.contentOffset.y...lastOffset).contains(stack.frame.origin.y){
                UIView.animate(withDuration: 1.5
                               , delay: 0
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                
                                stack.transform = .identity
                                stack.alpha = 1.0
                                
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 1.5
                               , delay: 0
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                
                                stack.alpha = 0.0
                                stack.transform = CGAffineTransform(translationX: -self.scrollView.frame.width, y: 0)
                                
                }, completion: nil)
            }
        }
    }
}
