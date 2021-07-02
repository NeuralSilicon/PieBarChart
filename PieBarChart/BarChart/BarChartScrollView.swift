
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

extension BarChart:UIScrollViewDelegate{
    
    func scrollToBar(at index:Int){
        guard index >= 0 && index < views.count else {return}
    
        if lastIndex != -1{
            removeShadow(for: views[lastIndex])
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.contentOffset.x = self.views[index].frame.origin.x - 8
        }, completion: nil)

        showShadow(for: views[index])
        
        lastIndex = index
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
         loop through our views and show the ones that are on
         the screen with animation, contentOffset.x..<to last offset which is the
         current offset + scrollView width if it contains the view.x value, then can be shown
         else we will remove them from page with animation
         */
        lastOffset = scrollView.contentOffset.x + scrollView.bounds.width
        for (_,view) in views.enumerated(){
            if (scrollView.contentOffset.x..<lastOffset).contains(view.frame.origin.x){
                UIView.animate(withDuration: 1.5
                               , delay: 0
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                view.transform = .identity
                                view.alpha = 1.0
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 1.5
                               , delay: 0
                               , usingSpringWithDamping: 0.8
                               , initialSpringVelocity: 0
                               , options: .allowUserInteraction
                               , animations: {
                                view.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
                                view.alpha = 0.0
                }, completion: nil)
            }
        }
    }
    

    
    private func showShadow(for view:UIView){
        let animator  = CABasicAnimation(keyPath: "shadowOpacity")
        animator.fromValue = 0.0
        animator.toValue = 0.5
        animator.duration = 1.0
        animator.autoreverses = false
        animator.repeatCount = 0
        view.layer.add(animator, forKey: "shadowOpacity")
        view.layer.shadowOpacity = 0.5
    }
    
    private func removeShadow(for view:UIView){
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
