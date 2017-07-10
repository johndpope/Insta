//
//  RecommendStatusViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/13.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RecommendStatusViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var barItem: UITabBarItem!
    
    override func viewDidLoad() {
        configureXLPagerTabStripSettings()
        
        super.viewDidLoad()

        configureUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        
    }
    
    private func configureXLPagerTabStripSettings() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let userActivity = UserActivityViewController.instantiate()
        let myActivity = MyActivityViewController.instantiate()
        return [userActivity, myActivity]
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

extension RecommendStatusViewController: ScrollableToTop {
    func scrollToTop() {
        (viewControllers[currentIndex] as? ScrollableToTop)?.scrollToTop()
    }
}
