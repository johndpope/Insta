//
//  CameraLibraryViewController.swift
//  Instagram
//
//  Created by 森 章人 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Photos
import PhotosUI

class CameraLibraryViewController: UIViewController, IndicatorInfoProvider {
    
    //ここがボタンのタイトルに利用されます
    let itemInfo: IndicatorInfo = "ライブラリ"
    
    lazy var albumView = FSAlbumView.instance()
    
    var fetchResult: PHFetchResult<PHAsset>!
    fileprivate let imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    init(frame : CGRect){
        super.init(nibName: nil, bundle: nil)
        albumView.frame = frame
        albumView.layoutIfNeeded()
        albumView.initialize()
        self.view.addSubview(albumView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
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
