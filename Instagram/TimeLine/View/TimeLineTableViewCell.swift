//
//  TimeLineTableViewCell.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/11.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import Kingfisher

class TimeLineTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var captionImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var postLikeImage: UIImageView!
    @IBOutlet weak var showCommentListButton: UIButton!
    
    private var comments: [PostCommentModel] = []
    
    private let commentRowHeight: CGFloat = 20
    
    private var postId: Int = 0
    private var likeCount: Int = 0
    private var isLike: Bool = false
    private var likeString: String {
        get {
            if self.isLike {
                self.isLike = false
                return "likeOff"
            } else {
                self.isLike = true
                return "likeOn"
            }
        }
    }
    
    private var cellViewModel: CellViewModel = .shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print("deinit")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with post: PostModel) {
        print(post.id)
        postId = post.id
        configure(with: post.user)
        configure(with: post.image)
        configure(with: post.like)
        configure(with: post.comments)
        configureSize()
        configureInteraction()
    }
    
    private func configure(with user: PostUserModel) {
        userIconImageView.kf.cancelDownloadTask()
        let iconImageURL = URL(string: user.iconURL)
        userNameLabel.text = user.name
        userIconImageView.kf.setImage(with: iconImageURL!, options: [.transition(.fade(0.3))])
        userIconImageView.layer.cornerRadius = userIconImageView.frame.size.height / 2
        userIconImageView.clipsToBounds = true
    }
    
    private func configure(with image: PostImageModel) {
        postImageView.kf.cancelDownloadTask()
        let postImageURL = URL(string: image.url)
        self.layoutIfNeeded()
        postImageHeightConstraint.constant = UIScreen.main.bounds.width * CGFloat(image.height) / CGFloat(image.width)
        postImageView.kf.setImage(with: postImageURL, options: [.transition(.fade(0.3))])
        postLikeImage.isHidden = true
    }
    
    private func configureSize() {
        let likeSize = likeImageView.frame.size
        captionImageView.image = captionImageView.image?.resizeUIImage(width: likeSize.width, height: likeSize.height * 0.7)
    }
    
    private func configure(with like: PostLikeModel) {
        likeCount = like.count
        isLike = like.ILikeIt
        
        if cellViewModel.dislikedPostIdSet.contains(postId) && isLike {
            likeCount -= 1
            isLike = false
        }
        if cellViewModel.likedPostIdSet.contains(postId) && !isLike {
            likeCount += 1
            isLike = true
        }
        
        if isLike {
            if cellViewModel.dislikedPostIdSet.contains(postId) {
                likeImageView.image = UIImage(named: "likeOff")!
            } else {
                likeImageView.image = UIImage(named: "likeOn")!
            }
        } else {
            if cellViewModel.likedPostIdSet.contains(postId) {
                likeImageView.image = UIImage(named: "likeOn")!
            } else {
                likeImageView.image = UIImage(named: "likeOff")!
            }
        }
        likeCountLabel.text = "\(likeCount)件"
    }
    
    private func configure(with comments: [PostCommentModel]) {
        if comments.count > 3 {
            self.comments = Array(comments.prefix(3))
            showCommentListButton.isEnabled = true
            showCommentListButton.isHidden = false
            showCommentListButton.addTarget(self, action: #selector(tappedShowButton), for: .touchUpInside)
        } else {
            self.comments = comments
            showCommentListButton.isEnabled = false
            showCommentListButton.isHidden = true
        }
        
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        commentTableView.separatorColor = UIColor.clear
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.rowHeight = commentRowHeight
        commentHeight.constant = commentRowHeight * CGFloat(self.comments.count)
        commentTableView.reloadData()
    }
    
    private func configureInteraction() {
        likeImageView.isUserInteractionEnabled = true
        postImageView.isUserInteractionEnabled = true
        let tapLikeGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLikeImageFromLike))
        let tapPostGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLikeImageFromPost))
        tapLikeGesture.numberOfTapsRequired = 1
        tapPostGesture.numberOfTapsRequired = 2
        
        likeImageView.addGestureRecognizer(tapLikeGesture)
        postImageView.addGestureRecognizer(tapPostGesture)
        
        
        likeCountLabel.isUserInteractionEnabled = true
        let taplikeCountGesture = UITapGestureRecognizer()
        taplikeCountGesture.numberOfTapsRequired = 1
        taplikeCountGesture.addTarget(self, action: #selector(tappedLikeCountLabel))
        
        likeCountLabel.addGestureRecognizer(taplikeCountGesture)
        
        likeLabel.isUserInteractionEnabled = true
        let taplikeGesture = UITapGestureRecognizer()
        taplikeGesture.numberOfTapsRequired = 1
        taplikeGesture.addTarget(self, action: #selector(tappedLikeCountLabel))
        
        likeLabel.addGestureRecognizer(taplikeGesture)
        
        captionImageView.isUserInteractionEnabled = true
        let tapCaptionGesture = UITapGestureRecognizer()
        tapCaptionGesture.numberOfTapsRequired = 1
        tapCaptionGesture.addTarget(self, action: #selector(tappedCaptionImageView))
        captionImageView.addGestureRecognizer(tapCaptionGesture)
    }
    
    func tappedLikeImageFromLike(_ recognizer: UITapGestureRecognizer) {
        if !isLike {
            cellViewModel.likedPostIdSet.insert(postId)
            cellViewModel.dislikedPostIdSet.remove(postId)
            likeCount += 1
            cellViewModel.postLike(with: postId)
        } else {
            cellViewModel.dislikedPostIdSet.insert(postId)
            cellViewModel.likedPostIdSet.remove(postId)
            likeCount -= 1
            cellViewModel.postDislike(with: postId)
        }
        likeCountLabel.text = "\(likeCount)件"
        likeImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.likeImageView.image = UIImage(named: self.likeString)
            self.likeImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func tappedLikeImageFromPost(_ recognizer: UITapGestureRecognizer) {
        if !isLike {
            self.likeCount += 1
            self.likeCountLabel.text = "\(self.likeCount)件"
            cellViewModel.likedPostIdSet.insert(postId)
            cellViewModel.dislikedPostIdSet.remove(postId)
            cellViewModel.postLike(with: postId)
        }
        isLike = true
        likeImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        postLikeImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        postLikeImage.isHidden = false
        postLikeImage.layer.zPosition = 1.0
        postImageView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.likeImageView.image = UIImage(named: "likeOn")
            self.likeImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            self.postLikeImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.postLikeImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, animations: { [unowned self] in
                self.postLikeImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { [unowned self] _ in
                self.postImageView.isUserInteractionEnabled = true
                self.postLikeImage.isHidden = true
            })
        })
    }
    
    func tappedLikeCountLabel() {
        cellViewModel.tappedPostId = postId
        cellViewModel.isLikeList.value = true
    }
    
    func tappedCaptionImageView() {
        cellViewModel.tappedPostId = postId
        cellViewModel.isCommentList.value = true
    }
    
    func tappedShowButton() {
        cellViewModel.tappedPostId = postId
        cellViewModel.isCommentList.value = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        cell.userNameLabel.text = comments[indexPath.row].userName
        cell.contentLabel.text = comments[indexPath.row].content
        return cell
    }
}
