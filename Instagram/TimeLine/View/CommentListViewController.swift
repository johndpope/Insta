//
//  CommentListViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/30.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

final class CommentListViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    
    private let viewModel = CommentListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureObserver()
        viewModel.getCommentList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        tableView.register(UINib(nibName: "CommentListTableViewCell", bundle: nil), forCellReuseIdentifier: "commentListCell")
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    private func configureObserver() {
        viewModel.commentLists.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "commentListCell", cellType: CommentListTableViewCell.self)) { index, list, cell in
                cell.configure(with: list)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading.asDriver()
            .skip(1)
            .drive(onNext: { isLoading in
                self.postButton.isEnabled = !isLoading
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    self.commentTextView.resignFirstResponder()
                    self.commentTextView.text = ""
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        commentTextView.rx.text
            .orEmpty
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { content in
                self.viewModel.content.value = content
            })
            .disposed(by: disposeBag)
        
        postButton.rx.tap
            .asObservable()
            .subscribe(onNext: {
                self.viewModel.postComment()
            })
            .disposed(by: disposeBag)
        
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo else {
            fatalError("Unexpected notification")
        }
        guard let keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            fatalError("No keyboard height found")
        }
        guard let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? Double) else {
            fatalError("No keyboard height found")
        }
        bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: animationDuration,
                       animations: { _ in
                        self.view.layoutIfNeeded()
        }
        )
    }
    
    func keyboardWillHide(notification: Notification) {
        guard let info = notification.userInfo else {
            fatalError("Unexpected notification")
        }
        guard let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? Double) else {
            fatalError("No keyboard height founcd")
        }
        bottomConstraint.constant = 0
        UIView.animate(withDuration: animationDuration,
                       animations: { _ in
                        self.view.layoutIfNeeded()
        }
        )
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
