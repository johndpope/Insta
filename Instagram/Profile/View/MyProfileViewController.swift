//
//  MyProfileViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/13.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SVProgressHUD

class MyProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionButton: UIView!
    
    var userId: Int? = nil
    weak var currentViewController: UIViewController?
    
    private let viewModel: ProfileViewModel = ProfileViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.fetchProfileInfo(with: userId)
        configureUI()
        configureObserver()
    }
    
    func addSubview(subView: UIView, to parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingDict = [String: AnyObject]()
        viewBindingDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingDict))
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, to: self.containerView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        tabBar.selectedItem = tabBar.items![0]
        profileButton.layer.borderWidth = 1.0
        profileButton.layer.borderColor = UIColor.lightGray.cgColor
        profileButton.layer.cornerRadius = 3
        profileButton.clipsToBounds = true
        
        if userId == nil {
            profileButton.setTitle("プロフィールを編集", for: .normal)
            
        } else {
            profileButton.setTitle("フォロー中", for: .normal)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.hidesBackButton = false
        }
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        tabBar.items![0].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        tabBar.items![1].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        tabBar.items![2].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        tabBar.items![3].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        
        
        let vc = UIStoryboard(name: "MyImageCollectionViewController", bundle: nil).instantiateInitialViewController() as! MyImageCollectionViewController
        vc.userId = self.userId
        currentViewController = vc
        currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, to: containerView)
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
        
        viewModel.profileInfo.asDriver()
            .skip(1)
            .drive(onNext: { info in
                let imageURL = URL(string: (info?.icon)!)
                let cornerRadius = self.profileImageView.frame.width / 2
                self.profileImageView.layer.cornerRadius = cornerRadius
                self.profileImageView.clipsToBounds = true
                self.profileImageView.kf.setImage(with: imageURL!, options: [.transition(.fade(0.3))])
                self.postCountLabel.text = String(describing: (info?.postCount)!)
                self.followerCountLabel.text = String(describing: (info?.followerCount)!)
                self.followingCountLabel.text = String(describing: (info?.followingCount)!)
                self.userNameLabel.text = info?.name
                self.navigationItem.title = info?.name
            })
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let vc = UIStoryboard(name: "EditMyProfileViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
                self.present(vc, animated: true)
            }).disposed(by: disposeBag)
        
        let optionButtonTap = UITapGestureRecognizer(target: self, action: #selector(optionButtonTapped))
        optionButtonTap.numberOfTapsRequired = 1
        optionButton.isUserInteractionEnabled = true
        optionButton.addGestureRecognizer(optionButtonTap)
    }
    
    func optionButtonTapped(){
        let vc = MyProfileOptionViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyProfileViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            let newViewController = UIStoryboard(name: "MyImageCollectionViewController", bundle: nil).instantiateInitialViewController() as! MyImageCollectionViewController
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        default:
            return
        }
    }
    
}

extension MyProfileViewController: ScrollableToTop {
    func scrollToTop() {
    }
}
