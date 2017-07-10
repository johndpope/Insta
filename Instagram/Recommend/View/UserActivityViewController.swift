//
//  UserActivityViewController.swift
//  Instagram
//
//  Created by 神場 貴之 on 2017/05/24.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import RxSwift
import RealmSwift
import SVProgressHUD

final class UserActivityViewController : UIViewController, Storyboardable {
    @IBOutlet weak var tableView: UITableView!
    private var refleshControl: UIRefreshControl!
    private let disposeBag = DisposeBag()
    fileprivate let viewModel = UserActivityViewModel()
    
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
        tableView.register(UINib(nibName: "UserActivityLikeTableViewCell", bundle: nil), forCellReuseIdentifier: "UserActivityLikeTableViewCellId")
        tableView.register(UINib(nibName: "UserActivityFollowTableViewCell", bundle: nil), forCellReuseIdentifier: "UserActivityFollowTableViewCellId")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.addSubview(refleshControl)
    }
    
    func configureObserver() {
        viewModel.activities.drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
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

extension UserActivityViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "フォロー中")
    }
}

extension UserActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: tableViewのdatasourceをrxに変えるとviewModelへの参照がなくなる
        return viewModel._activities.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: tableViewのdatasourceをrxに変えるとviewModelへの参照がなくなる
        let body = viewModel._activities.value[indexPath.row].body
        switch body {
        case let body as UserActivityLikeModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityLikeTableViewCellId", for: indexPath) as! UserActivityLikeTableViewCell
            cell.configure(body)
            return cell
        case let body as UserActivityFollowModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityFollowTableViewCellId", for: indexPath) as! UserActivityFollowTableViewCell
            cell.configure(body)
            return cell
        default:
            fatalError()
        }
    }
}

extension UserActivityViewController: ScrollableToTop {
    func scrollToTop() {
        scrollToTop(tableView)
    }
}
