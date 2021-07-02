
import UIKit

class Tabbar:UIViewController, UIPageViewControllerDelegate, UIScrollViewDelegate{

    var tabbar:UIView!

    var menu:[UIButton]!
    var buttonTag:Int = 0
    
    var containerView:UIView!
    var pageViewController: UIPageViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.containerView.layoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard pageViewController == nil else {
            return
        }
        configPageController()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        //reset pagecontroller
        menus(menu[0])
    }
        
}
