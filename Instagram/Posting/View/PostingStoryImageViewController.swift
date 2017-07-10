//
//  PostingStoryImageViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/23.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PostingStoryImageViewController: UIViewController {

    @IBOutlet weak var postingStoryImageView: UIImageView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    
    var postingStoryImage: UIImage?
    
    private var viewModel = PostingStoryImageViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postingStoryImageView.image = postingStoryImage
        prepareForPost()
        configureUI()
        configureObserver()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareForPost() {
        guard let image = self.postingStoryImage else {
            return
        }
        
        let imageData = UIImagePNGRepresentation(image)!
        
        viewModel.set(of: imageData)
    }

    
    private func configureUI() {
        postImageView.layer.zPosition = 1.0
        closeImageView.layer.zPosition = 1.0
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(back))
        
        let postTapGesture = UITapGestureRecognizer()
        postTapGesture.numberOfTapsRequired = 1
        postTapGesture.addTarget(self, action: #selector(post))
        
        closeImageView.isUserInteractionEnabled = true
        closeImageView.addGestureRecognizer(tapGesture)
        
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(postTapGesture)
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    func post() {
        viewModel.postStoryImage()
    }
    
    
    private func configureObserver() {
        viewModel.isLoading.asDriver()
            .skip(1)
            .distinctUntilChanged()
            .drive(onNext: { isLoading in
                if !isLoading {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading.asDriver()
            .skip(1)
            .distinctUntilChanged()
            .drive(onNext: { isLoading in
                if !isLoading {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
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
