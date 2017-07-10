//
//  MyActivityViewController.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import RxSwift
import SVProgressHUD

final class MyActivityViewController: UIViewController, Storyboardable {
    @IBOutlet weak var tableView: UITableView!
    private var refleshControl: UIRefreshControl!
    fileprivate let viewModel = MyActivityUserModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        configureRefreshControl()
        configureTableView()
        configureObserver()
        
        viewModel.initialFetch()
    }
    
    private func configureRefreshControl() {
        refleshControl = UIRefreshControl()
        refleshControl?.addTarget(self, action: #selector(reloadActivity), for: .valueChanged)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "MyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "MyActivityTableViewCellId")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.addSubview(refleshControl)
    }
    
    private func configureObserver() {
        viewModel.activities.drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
        viewModel.blockUI.drive(onNext: { blocking in
            if blocking {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] loading in
            if !loading {
                self?.refleshControl?.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }
    
    func reloadActivity() {
        viewModel.pullTorefresh()
    }
}

extension MyActivityViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "あなた")
    }
}

extension MyActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: tableViewのdatasourceをrxに変えるとviewModelへの参照がなくなる
        return viewModel._activities.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel._activities.value[indexPath.row]
        // TODO: tableViewのdatasourceをrxに変えるとviewModelへの参照がなくなる
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyActivityTableViewCellId", for: indexPath) as! MyActivityTableViewCell
        cell.configure(model)
        addFollowButtonGesture(cell, index: indexPath.row)
        return cell
    }
    
    private func addFollowButtonGesture(_ cell: MyActivityTableViewCell, index: Int) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.followButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        cell.button.tag = index
        cell.button.isUserInteractionEnabled = true
        cell.button.addGestureRecognizer(tapGesture)
    }
}

extension MyActivityViewController: UnfollowActionSheetSupport {
    func followButtonTapped(_ recognizer: UITapGestureRecognizer) {
        let index = (recognizer.view?.tag)!
        let activity = viewModel._activities.value[index]
        let userId = activity.myFollowingUserId
        if activity.isFollowing {
            presentUnfollowActionSheet(userName: activity.myFollowingUserName) { action in
                self.viewModel.unfollow(index: index, userId: activity.myFollowingUserId)
            }
        } else {
            viewModel.follow(index: index, userId: userId)
        }
    }
}


extension MyActivityViewController: ScrollableToTop {
    func scrollToTop() {
        scrollToTop(tableView)
    }
}
