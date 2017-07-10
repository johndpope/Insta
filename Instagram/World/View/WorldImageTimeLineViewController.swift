//
//  WorldImageTimeLineViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/13.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import AVFoundation

class WorldImageTimeLineViewController: UIViewController {

    
    @IBOutlet weak var storyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var storyView: WorldStoryView!
    @IBOutlet weak var barItem: UITabBarItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerImageView: UIImageView?
    var playerView: UIView?
    var numberOfImageCollection = 0
    private var refleshControl: UIRefreshControl?
    
    let viewModel = WorldImageTimeLineViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.fetchTimeLine()
        configureUI()
        configureObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func configureUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        refleshControl = UIRefreshControl()
        refleshControl?.addTarget(self, action: #selector(reloadTimeLine), for: .valueChanged)
        
        imageCollectionView.delegate = self
        
        storyView.collectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "storyCell")
        storyView.configureUI()
        imageCollectionView.register(UINib(nibName: "WorldImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCollectionCell")
        
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action: #selector(resignKeyboard))
        imageCollectionView.addGestureRecognizer(gesture)
    }
    
    func resignKeyboard() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    private func configureObserver() {
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
        
        
        viewModel.posts.asDriver()
            .drive(imageCollectionView.rx.items(cellIdentifier: "imageCollectionCell", cellType: WorldImageCollectionViewCell.self)) { index, post, cell in
                cell.configure(with: post)
                //cell.configureCell()
            }
            .disposed(by: disposeBag)
        
        viewModel.stories.asDriver()
            .drive(storyView.collectionView.rx.items(cellIdentifier: "storyCell", cellType: StoryCollectionViewCell.self)) { [unowned self] index, story, cell in
                cell.configure(with: story)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.playStory))
                tapGesture.numberOfTapsRequired = 1
                cell.userImageView.tag = index
                cell.userImageView.isUserInteractionEnabled = true
                cell.userImageView.addGestureRecognizer(tapGesture)
            }
            .disposed(by: disposeBag)

        
        /*
        imageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        imageCollectionView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)*/
        

    }
    
    func reloadTimeLine() {
        viewModel.fetchTimeLine()
        
        refleshControl?.endRefreshing()
    }
    
    func playStory(_ recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        let storyType = viewModel.storyTypes.value[index]
        
        let removeGesture = UITapGestureRecognizer(target: self, action: #selector(stopStory))
        removeGesture.numberOfTapsRequired = 1
        let window = UIApplication.shared.keyWindow
        
        if storyType == .video {
            player = viewModel.storyVideos.value[index]?.player
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerLayer?.frame = UIScreen.main.bounds
            playerView = UIView(frame: UIScreen.main.bounds)
            playerView?.layer.addSublayer(playerLayer!)
            
            playerView?.tag = index
            playerView?.addGestureRecognizer(removeGesture)
            
            window?.addSubview(playerView!)
            player?.play()
        }
        
        if storyType == .image {
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.kf.cancelDownloadTask()
            imageView.kf.setImage(with: viewModel.storyImages.value[index])
            playerImageView = imageView
            
            playerImageView?.tag = index
            playerImageView?.isUserInteractionEnabled = true
            playerImageView?.addGestureRecognizer(removeGesture)
            
            window?.addSubview(playerImageView!)
        }
    }
    
    
    
    func stopStory(_ recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        let storyType = viewModel.storyTypes.value[index]
        viewModel.storyVideos.value[index]?.player?.seek(to: kCMTimeZero)
        if storyType == .video {
            playerView?.removeFromSuperview()
            let qos = DispatchQoS.QoSClass.background
            DispatchQueue.global(qos: qos).async { [unowned self] _ in
                self.player = nil
                self.playerLayer = nil
                self.playerView = nil
            }
        }
        
        if storyType == .image {
            playerImageView?.removeFromSuperview()
            playerImageView = nil
        }
    }
}


extension WorldImageTimeLineViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.size.width / 4 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
}

extension WorldImageTimeLineViewController: ScrollableToTop {
    func scrollToTop() {
        
    }
}
