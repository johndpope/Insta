//
//  CameraShotViewController.swift
//  Instagram
//
//  Created by 森 章人 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Photos
import PhotosUI


class CameraShotViewController: UIViewController, IndicatorInfoProvider, FSCameraViewDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    //ここがボタンのタイトルに利用されます
    let itemInfo: IndicatorInfo = "写真"
    
    lazy var cameraView = FSCameraView.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraView.initialize()
        cameraView.shotButton.isEnabled = true
    }
    
    init(frame : CGRect){
        super.init(nibName: nil, bundle: nil)
        cameraView.delegate = self as FSCameraViewDelegate
        cameraView.frame = self.view.frame
        cameraView.layoutIfNeeded()
        DispatchQueue.main.async {
            self.cameraView.initialize()
        }
        self.view.addSubview(cameraView)
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
    
    func cameraShotFinished(_ image: UIImage) {
        cameraView.shotButton.isEnabled = false
        DispatchQueue.main.async() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            let adobeViewController = AdobeUXImageEditorViewController(image: image)
            adobeViewController.delegate = self as? AdobeUXImageEditorViewControllerDelegate
            self.present(adobeViewController, animated: true, completion:  nil)
        }
    }
    
    // AdobeImageEditorで加工を完了したときに呼ばれる
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        print("Hello")
        editor.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "PostingImageViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostingImageViewController") as! PostingImageViewController
        vc.postProcessingImage = image!
        
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true, completion:  nil)
    }
    
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        editor.dismiss(animated: true, completion: nil)
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
