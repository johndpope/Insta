//
//  TimeLineStoryPageViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/18.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit

class TimeLineStoryPageViewController: UIPageViewController {
    
    var viewControllerList: [UIViewController] = []
    let initialIndex: Int = 1
    var currentIndex: Int = 1
    var pageEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewControllers()
        setScrollViewDelegate()
        self.dataSource = self
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initViewControllers() {
        let instagramVC = UIStoryboard(name: "InstagramTabViewController", bundle: nil).instantiateInitialViewController() as! InstagramTabViewController
        instagramVC.pageViewDelegate = self
        let storyCameraVC = UIStoryboard(name: "StoryCameraViewController", bundle: nil).instantiateInitialViewController() as! StoryCameraViewController
        storyCameraVC.configureCamera()
        
        viewControllerList = [storyCameraVC, instagramVC]
        setViewController(viewControllerList[initialIndex])
    }
    
    private func setViewController(_ viewController: UIViewController) {
        self.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
    }
    
    fileprivate func reloadDataSource() {
        //dataSource = nil
        //dataSource = self
        setViewController(viewControllers![0])
    }
    
    fileprivate func pageCount() -> Int {
        return viewControllerList.count
    }
    
    private func setScrollViewDelegate() {
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }
    }
}

extension TimeLineStoryPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard pageEnabled && currentIndex + 1 < viewControllerList.count else { return nil }
        return viewControllerList[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard pageEnabled && currentIndex - 1 >= 0 else { return nil }
        return viewControllerList[currentIndex - 1]
    }
}

extension TimeLineStoryPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed
        {
            currentIndex = (viewControllers![0].isKind(of: StoryCameraViewController.self)) ? 0 : 1
        }
    }
}

extension TimeLineStoryPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustContentOffset(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        adjustContentOffset(scrollView)
    }
    
    private func adjustContentOffset(_ scrollView: UIScrollView) {
        if
            (!pageEnabled) ||
                (currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) ||
                (currentIndex == pageCount() - 1
                    && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}

extension TimeLineStoryPageViewController: PageViewEnabledDelegate {
    func setPageViewEnabled(_ enabled: Bool) {
        pageEnabled = enabled
        reloadDataSource()
    }
}
