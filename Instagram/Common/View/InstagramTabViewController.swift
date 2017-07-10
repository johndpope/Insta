//
//  InstagramTabViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

class InstagramTabViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    weak var currentViewController: UIViewController?
    var pageViewDelegate: PageViewEnabledDelegate?
    
    fileprivate var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items![0].image = UIImage(named: "homeOff")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![0].selectedImage = UIImage(named: "homeOn")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![0].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.items![1].image = UIImage(named: "searchOff")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![1].selectedImage = UIImage(named: "searchOn")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![1].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.items![2].image = UIImage(named: "postOff")?.resizeUIImage(width: 35, height: 35)
        tabBar.items![2].selectedImage = UIImage(named: "postOff")?.resizeUIImage(width: 35, height: 35)
        tabBar.items![2].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.items![3].image = UIImage(named: "heartOff")?.resizeUIImage(width: 29, height: 23)
        tabBar.items![3].selectedImage = UIImage(named: "heartOn")?.resizeUIImage(width: 27, height: 21)
        tabBar.items![3].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.items![4].image = UIImage(named: "profileOff")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![4].selectedImage = UIImage(named: "profileOn")?.resizeUIImage(width: 25, height: 25)
        tabBar.items![4].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        
        currentViewController = UIStoryboard(name: "MyTimeLineViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
        currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, to: containerView)
        // Do any additional setup after loading the view.
    }
    
    func addSubview(subView: UIView, to parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingDict = [String: AnyObject]()
        viewBindingDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingDict))
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, to: self.containerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentIndex == 0 {
            setPageViewEnabled(0)
        }
    }
}

extension InstagramTabViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard currentIndex != item.tag else {
            scrollToTop(currentIndex)
            return
        }
        setPageViewEnabled(item.tag)
        changeViewController(item.tag)
    }
    
    fileprivate func setPageViewEnabled(_ index: Int) {
        let pageViewEnabled = (index == 0)
        pageViewDelegate?.setPageViewEnabled(pageViewEnabled)
    }
    
    private func changeViewController(_ index: Int) {
        switch index {
        case 0:
            let newViewController = UIStoryboard(name: "MyTimeLineViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
            currentIndex = index
        case 1:
            let newViewController = UIStoryboard(name: "WorldImageTimeLineViewController", bundle: nil).instantiateInitialViewController() as! WorldImageTimeLineViewController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
            currentIndex = index
        case 2:
            let newViewController = UIStoryboard(name: "CameraRootViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
            self.present(newViewController, animated: true, completion: nil)
            /*
             newViewController.view.translatesAutoresizingMaskIntoConstraints = false
             self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
             self.currentViewController = newViewController*/
        case 3:
            let newViewController = UIStoryboard(name: "RecommendStatusViewController", bundle: nil).instantiateInitialViewController() as! RecommendStatusViewController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
            currentIndex = index
        case 4:
            let newViewController = UIStoryboard(name: "MyProfileViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
            currentIndex = index
        default:
            return
        }
    }
    
    private func scrollToTop(_ index: Int) {
        switch index {
        case 0:
            guard
                let nav = currentViewController as? UINavigationController,
                case let vc = nav.visibleViewController,
                let myTimeline = vc as? MyTimeLineViewController
                else { return }
            myTimeline.scrollToTop()
        case 1:
            guard
                let worldTimeline = currentViewController as? WorldImageTimeLineViewController
                else { return }
            worldTimeline.scrollToTop()
        case 3:
            guard
                let recommend = currentViewController as? RecommendStatusViewController
                else { return }
            recommend.scrollToTop()
        case 4:
            guard
                let nav = currentViewController as? UINavigationController,
                case let vc = nav.visibleViewController,
                let profile = vc as? MyProfileViewController
                else { return }
            profile.scrollToTop()
        default:
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
