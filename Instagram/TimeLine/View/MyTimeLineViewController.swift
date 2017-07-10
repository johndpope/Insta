//
//  MyTimeLineViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/09.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import SVProgressHUD
import Kingfisher

class MyTimeLineViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var barItem: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storyView: StoryView!
    @IBOutlet weak var instagramLogo: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerImageView: UIImageView?
    var playerView: UIView?
    private var refleshControl: UIRefreshControl?
    private var cache = ImageCache.default
    
    private let viewModel = MyTimeLineViewModel()
    private let cellViewModel: CellViewModel = .shared
    private let disposeBag = DisposeBag()
    
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
        tableView.register(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "timeLineCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.addSubview(refleshControl!)
        
        storyView.collectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "storyCell")
        storyView.configureUI()
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(clearCache))
        gesture2.numberOfTapsRequired = 1
        instagramLogo.isUserInteractionEnabled = true
        instagramLogo.addGestureRecognizer(gesture2)
    }
    
    private func configureObserver() {
        cellViewModel.isLikeList.asDriver()
            .drive(onNext: { [weak self] isLikeList in
                if isLikeList {
                    let vc = UIStoryboard(name: "LikeListViewController", bundle: nil).instantiateViewController(withIdentifier: "likelist") as! LikeListViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        cellViewModel.isCommentList.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] isCommentList in
                if isCommentList {
                    let vc = UIStoryboard(name: "CommentListViewController", bundle: nil).instantiateViewController(withIdentifier: "commentList") as! CommentListViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.posts.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "timeLineCell", cellType: TimeLineTableViewCell.self)) { [weak self] index, post, cell in
                cell.configure(with: post)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.moveToProfile))
                tapGesture.numberOfTapsRequired = 1
                cell.userIconImageView.tag = index
                cell.userIconImageView.isUserInteractionEnabled = true
                cell.userIconImageView.addGestureRecognizer(tapGesture)
            }
            .disposed(by: disposeBag)
        
        viewModel.stories.asDriver()
            .drive(storyView.collectionView.rx.items(cellIdentifier: "storyCell", cellType: StoryCollectionViewCell.self)) { [weak self] index, story, cell in
                cell.configure(with: story)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.playStory))
                tapGesture.numberOfTapsRequired = 1
                cell.userImageView.tag = index
                cell.userImageView.isUserInteractionEnabled = true
                cell.userImageView.addGestureRecognizer(tapGesture)
            }
            .disposed(by: disposeBag)
        
        storyView.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom.asObservable()
            .filter { [unowned self] _ in
                self.viewModel.untilId.value > 1
            }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchMoreTimeLine()
            })
            .disposed(by: disposeBag)
    }
    
    func reloadTimeLine() {
        refleshControl?.endRefreshing()
        viewModel.fetchTimeLine()
    }
    
    func moveToProfile(_ recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        let userId = viewModel.posts.value[index].user.id
        
        let storyboard = UIStoryboard(name: "MyProfileViewController", bundle: nil)
        let profVC = storyboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileViewController
        profVC.userId = userId
        
        self.navigationController?.pushViewController(profVC, animated: true)
        
    }
    
    func playStory(_ recognizer: UITapGestureRecognizer) {
        print("play")
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
            playerView?.backgroundColor = UIColor.black
            
            playerView?.tag = index
            playerView?.addGestureRecognizer(removeGesture)
            
            window?.addSubview(playerView!)
            player?.play()
        }
        
        if storyType == .image {
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            let qos = DispatchQoS.QoSClass.background
            DispatchQueue.global(qos: qos).async { [weak self] _ in
                imageView.kf.cancelDownloadTask()
                imageView.kf.setImage(with: self?.viewModel.storyImages.value[index])
            }
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
            DispatchQueue.global(qos: qos).async { [weak self] _ in
                self?.player = nil
                self?.playerLayer = nil
                self?.playerView = nil
            }
        }
        
        if storyType == .image {
            playerImageView?.removeFromSuperview()
            let qos = DispatchQoS.QoSClass.background
            DispatchQueue.global(qos: qos).async { [weak self] _ in
                self?.playerImageView = nil
            }
        }
    }
    
    func moveToStoryCamera() {
        self.performSegue(withIdentifier: "storyCameraSegue", sender: nil)
    }
    
    func clearCache() {
    }
}

extension MyTimeLineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(7, 10, 0, 10)
    }
}

extension MyTimeLineViewController: AVAssetDownloadDelegate {
}

extension MyTimeLineViewController: ScrollableToTop {
    func scrollToTop() {
        scrollToTop(tableView)
    }
}
