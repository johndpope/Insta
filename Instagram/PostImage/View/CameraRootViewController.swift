//
//  CameraRootViewController.swift
//  Instagram
//
//  Created by 森 章人 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Photos
import PhotosUI


class CameraRootViewController: ButtonBarPagerTabStripViewController, AdobeUXImageEditorViewControllerDelegate {
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)

    fileprivate let imageManager = PHCachingImageManager()
    var libraryVC: CameraLibraryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.blueInstagramColor
            if(self?.currentIndex == 0)
            {
                let nextButton = UIBarButtonItem(title: "次へ", style: UIBarButtonItemStyle.plain, target: self,
                                                 action: #selector(CameraRootViewController.goFilter))
                nextButton.tintColor = nil
                self?.navigationController?.navigationBar.tintColor = nil
                self?.navigationItem.title = "すべての写真"
                self?.navigationItem.rightBarButtonItem = nextButton
            }else{
                self?.navigationItem.title = "写真"
                self?.navigationItem.rightBarButtonItem = nil
            }
            let cancel = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self?.cancelButtonTapped))
            self?.navigationItem.setLeftBarButton(cancel, animated: true)

        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func goFilter(){
        let image = libraryVC?.albumView.imageCropView.image

        DispatchQueue.main.async() {
            let adobeViewController = AdobeUXImageEditorViewController(image: image!)
            adobeViewController.delegate = self
            self.present(adobeViewController, animated: true, completion:  nil)
        }
    }
    
    // AdobeImageEditorで加工を完了したときに呼ばれる
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        libraryVC =  CameraLibraryViewController(frame: UIScreen.main.bounds)
        let shotVC = CameraShotViewController(frame: UIScreen.main.bounds)
        return [libraryVC!, shotVC]
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true)
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
