//
//  PostingStoryVideoViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import SVProgressHUD

final class PostingStoryVideoViewController: UIViewController, Storyboardable {

    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var closeImageView: UIImageView!
    
    var videoURL: URL?
    
    private var viewModel = PostingStoryVideoViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let asset = AVAsset(url: videoURL!)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
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
        guard let url = self.videoURL else {
            return
        }
        
        let videoData = try! Data(contentsOf: url)
        
        viewModel.set(of: videoData)
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
        viewModel.postStoryVideo()
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
