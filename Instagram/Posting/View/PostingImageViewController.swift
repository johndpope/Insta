//
//  PostingImageViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/15.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PostingImageViewController: UIViewController {

    @IBOutlet weak var locationCellView: CommomCellView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    
    var postProcessingImage: UIImage? = nil
    
    
    private var viewModel = PostingImageViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        prepareForPost()
        configureUI()
        configureGesture()
        configureObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func prepareForPost() {
        //let image = UIImage(contentsOfFile: "/Users/a14757/Pictures/bari.jpeg")!
        guard let image = self.postProcessingImage else {
            return
        }
        
        let imageData = UIImagePNGRepresentation(image)!
        
        viewModel.set(of: imageData)
    }
    
    private func configureUI() {
        imageView.image = postProcessingImage!
        locationCellView.iconImageView.image = UIImage(named: "pin")
        locationCellView.textLabel.text = "位置情報を追加"
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(back))
        tapGesture.numberOfTapsRequired = 1
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tapGesture)
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureObserver() {
        captionTextField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.caption)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .do(onNext: { _ in
                self.shareButton.isEnabled = false
            })
            .subscribe(onNext: {
                self.viewModel.postImage()
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
