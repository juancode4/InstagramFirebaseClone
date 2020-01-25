//
//  commentInputAccessoryView.swift
//  Instagram Firebase
//
//  Created by Juan Navarro on 1/23/20.
//  Copyright © 2020 Juan Navarro. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {

    var delegate: CommentInputAccessoryViewDelegate?

    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.showPlaceHolderLabel()
    }

    fileprivate let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    fileprivate let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        return tv
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        autoresizingMask = .flexibleHeight

        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)

        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)

        setupLineSeperatorView()

    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    fileprivate func setupLineSeperatorView() {
        let lineSeperatorView = UIView()
        lineSeperatorView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)


    }

    @objc func handleSubmit() {

        guard let commentText = commentTextView.text else { return }

        delegate?.didSubmit(for: commentText)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

