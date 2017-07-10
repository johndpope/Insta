//
//  LikeListViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/23.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LikeListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = LikeListViewModel()
    private let cellViewModel: CellViewModel = .shared
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        configureObserver()
        viewModel.getLikeList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        tableView.register(UINib(nibName: "LikeListTableViewCell", bundle: nil), forCellReuseIdentifier: "likeListCell")
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        cellViewModel.isLikeList.value = false
    }
    
    private func configureObserver() {
        viewModel.likelists.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "likeListCell", cellType: LikeListTableViewCell.self)) { index, list, cell in
                cell.configure(with: list)
            }
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
