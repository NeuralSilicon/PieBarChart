
import UIKit

extension Tabbar:UIPageViewControllerDataSource{

    //MARK: -Model Handler
    func pageControllerIndex(for index:Int){
        let startingViewController: UIViewController = viewControllerAtIndex(index)!
        let viewControllers = [startingViewController]
            viewControllers.first?.view.frame = self.containerView.bounds
        self.pageViewController.setViewControllers(viewControllers,
                                                   direction: .forward
                                                       , animated: false, completion: {done in })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.index(for: viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
     }
     
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.index(for: viewController)
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == 3 {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func index(for viewController:UIViewController) -> Int{
        return viewController.view.tag
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {

        if (index == -1) || (index >= 3){
            return nil
        }
        switch index {
        case 0: // bar
            let bar = BarChart()
            bar.view.tag = 0
            return bar
        case 1: // pie
            let pie = PieChart()
            pie.view.tag = 1
            return pie
        case 2: // both
            let both = PieBChart()
            both.view.tag = 2
            return both
        default:
            break
        }
    
        return nil
    }

    
}
