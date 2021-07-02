
import UIKit

extension Tabbar{
    
    //MARK: -PageController
    func configPageController(){
        
        containerView = UIView()
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.tabbar.topAnchor, constant:.bottomConstant)
        ])
            
        view.layoutIfNeeded()
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.clipsToBounds = true
        pageViewController.view.frame = containerView.bounds
        pageViewController.view.backgroundColor = .clear
        
        self.addChild(self.pageViewController!)
        containerView.addSubview(self.pageViewController!.view)
        
        ///access page Controller scrollView
        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
       
        pageViewController!.didMove(toParent: self)
        containerView.layoutIfNeeded()
        
        //init pagecontroller
        pageControllerIndex(for: 0)
        self.view.bringSubviewToFront(self.tabbar)
    }
    
    
    //MARK: -Tabbar
    func configTabbar(){
        tabbar = UIView()
        view.backgroundColor = UIColor.systemBackground
        tabbar.backgroundColor = UIColor.systemBackground
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabbar)
        
        NSLayoutConstraint.activate([
            tabbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbar.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.view.layoutIfNeeded()
        
        //Add Hstack to tabbar
        menu = []
        
        let hStack = UIStackView()
        hStack.distribution = .fillEqually
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        tabbar.addSubview(hStack)
    
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: tabbar.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: tabbar.bottomAnchor, constant: -30),
            hStack.leadingAnchor.constraint(equalTo: tabbar.leadingAnchor, constant: 30),
            hStack.trailingAnchor.constraint(equalTo: tabbar.trailingAnchor, constant: -30)
        ])
        
        tabbar.layoutIfNeeded()
        
        let icons = ["chart.bar.fill","chart.pie.fill","rectangle.split.1x2.fill"]
        //Add icons to hStack
        for i in 0...2{
                        
                let button = UIButton()
                button.tag = i
                
                if let img = UIImage(systemName: icons[i])?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .regular)){
                    button.setImage(img, for: .normal)
                    button.tintColor = .label.withAlphaComponent(0.5)
                }
                            
                button.layer.masksToBounds = true
                button.backgroundColor = .clear
                hStack.addArrangedSubview(button)
                hStack.layoutIfNeeded()
                button.addTarget(self, action: #selector(menus), for: .touchUpInside)
                menu.append(button)

        }
        
        //Activate first button
        menu.first?.tintColor = .label
        menu.first?.isSelected = true
    }
    
    
    //MARK: -Menu Buttons Action
    @objc func menus(_ sender:UIButton){
        for button in menu{
            if button != sender{
                button.tintColor = .label.withAlphaComponent(0.5)
                button.isSelected = false
            }else{
                button.tintColor = .label
                button.isSelected = true
            }
        }
        pageControllerIndex(for: sender.tag)
        
        buttonTag = sender.tag
    }

    
}
