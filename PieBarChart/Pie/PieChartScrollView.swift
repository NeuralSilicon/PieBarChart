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

extension PieChart: UIScrollViewDelegate{
    
    func scroll(to index: Int) {
        
        if self.prevStackViewIndex != -1{
            removeShadow(for: pieChartUI.stackViews[prevStackViewIndex])
        }
        self.prevStackViewIndex = index
        
        if orientation == .Vertical{
            guard let stack = pieChartUI.stack(for: index) else {return}
            
            let lastOffset = scrollView.contentOffset.y + scrollView.bounds.height
            let stackPosi = stack.frame.origin.y + (stack.frame.height / 2)
          
            if !(scrollView.contentOffset.y...lastOffset).contains(stackPosi){
                scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: stack.frame.origin.y), size: scrollView.frame.size), animated: true)
            }
        }else{
            guard let stack = pieChartUI.stack(Hfor: index) else {return}
            
            let lastOffset = scrollView.contentOffset.x + scrollView.bounds.width
   
            if !(scrollView.contentOffset.x...lastOffset).contains(stack.frame.origin.x){

                self.scrollView.contentOffset.x = self.scrollView.frame.width * CGFloat(index / pieChartUI.stackCount)
            }
        }
        delegate?.barChar(for: index)
        showShadow(for: pieChartUI.stackViews[index])
    }
    


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
         loop through our views and show the ones that are on
         the screen with animation, contentOffset.x..<to last offset which is the
         current offset + scrollView width if it contains the view.x value, then can be shown
         else we will remove them from page with animation
         */
        if orientation == .Vertical{
            self.verticalScrolling()
        }else{
            self.horizontalScrolling()
        }
    }
    
    
    func shadow(for view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.shadowOpacity = 0.0
    }
    
    func showShadow(for view:UIView){
        let animator  = CABasicAnimation(keyPath: "shadowOpacity")
        animator.fromValue = 0.0
        animator.toValue = 0.5
        animator.duration = 1.0
        animator.autoreverses = false
        animator.repeatCount = 0
        view.layer.add(animator, forKey: "shadowOpacity")
        view.layer.shadowOpacity = 0.5
    }
    
    func removeShadow(for view:UIView){
        let animator  = CABasicAnimation(keyPath: "shadowOpacity")
        animator.fromValue = 0.5
        animator.toValue = 0.0
        animator.duration = 1.0
        animator.autoreverses = false
        animator.repeatCount = 0
        view.layer.add(animator, forKey: "shadowOpacity")
        view.layer.shadowOpacity = 0.0
    }
}
