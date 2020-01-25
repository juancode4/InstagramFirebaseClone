//
//  CommentsController.swift
//  Instagram Firebase
//
//  Created by Juan Navarro on 1/16/20.
//  Copyright © 2020 Juan Navarro. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {

    var post: Post?

    let cellId = "cellId"


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive

        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)

        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)



        setupNavTitle()

        fetchComments()
    }

    var comments = [Comment]()
    fileprivate func fetchComments() {

        guard let postId = self.post?.id else { return }

        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String: Any] else { return }

            guard let uid = dictionary["uid"] as? String else { return }

            Database.FetchUserWithUID(uid: uid) { (user) in

                let comment = Comment(user: user, dictionary: dictionary)

                self.comments.append(comment)
                self.collectionView.reloadData()
            }

        }) { (error) in
            print("failed to observe comments")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let frame = containerView.frame

        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()

        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)

        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell

        cell.comment = self.comments[indexPath.item]

        return cell
    }

    func setupNavTitle() {
        navigationItem.title = "Comments"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    lazy var containerView: CommentInputAccessoryView = {

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAcessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAcessoryView.delegate = self
        return commentInputAcessoryView
    }()

    func didSubmit(for comment: String) {
        print("Trying to submit comment into firebase")

            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("post id:", post?.id as Any)
        print("Handle submit: *\(comment)*")

            let postId = self.post?.id ?? ""
            let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
            Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Failed to insert comment:", error)
                    return
                }
                print("successfully inserted comment")

                self.containerView.clearCommentTextView()

            }

        }

    override var inputAccessoryView: UIView? {
        get {

            return containerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}
