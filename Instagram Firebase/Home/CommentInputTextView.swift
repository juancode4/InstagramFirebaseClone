//
//  CommentInputTextView.swift
//  Instagram Firebase
//
//  Created by Juan Navarro on 1/23/20.
//  Copyright © 2020 Juan Navarro. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {

    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = .lightGray
        return label
    }()

    func showPlaceHolderLabel() {
        placeholderLabel.isHidden = false
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)

        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }

    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

