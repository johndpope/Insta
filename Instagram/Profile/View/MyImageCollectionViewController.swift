//
//  MyImageCollectionViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/22.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class MyImageCollectionViewController: UIViewController {

    
    @IBOutlet weak var imageGridCollectionView: UICollectionView!
    
    var userId: Int?
    
    let viewModel: ProfileViewModel = ProfileViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.fetchImageGrid(with: userId)
        configureUI()
        configureObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        imageGridCollectionView.delegate = self
        imageGridCollectionView.register(UINib(nibName: "MyImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "grid")
    }
    

    private func configureObserver() {
        viewModel.isGridLoading.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.imagesPath.asDriver()
            .drive(imageGridCollectionView.rx.items(cellIdentifier: "grid", cellType: MyImageCollectionViewCell.self)) { index, gridCell, cell in
                cell.configure(with: gridCell)
            }
            .disposed(by: disposeBag)
    }
}


extension MyImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width / 3 - 1
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
        return viewModel.imagesPath.value.count
    }
}
