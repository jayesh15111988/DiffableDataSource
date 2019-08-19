//
//  SubHeaderView.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/17/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class SubHeaderView: UICollectionReusableView {

    struct ViewModel {
        let labelTitle: String
        let buttonTitle: String
        let attachmentImage: UIImage?
    }

    enum Constants {
        static let horizontalPadding: CGFloat = 20.0
        static let verticalPadding: CGFloat = 10.0
        static let imageSize: CGFloat = 34.0
    }

    static let reuseIdentifier = "sub-header-reusable-view"
    let label: UILabel
    let button: UIButton

    override init(frame: CGRect) {
        label = UILabel()
        button = UIButton()

        super.init(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        addSubview(label)
        addSubview(button)
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            label.trailingAnchor.constraint(lessThanOrEqualTo: button.leadingAnchor, constant: -Constants.horizontalPadding),
            button.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding)
            ])
    }

    func apply(viewModel: SubHeaderView.ViewModel) {

        let labelTitle = viewModel.attachmentImage != nil ? viewModel.labelTitle + "  " : viewModel.labelTitle

        let fullAttributedString = NSMutableAttributedString(string: labelTitle)

        if let attachmentImage = viewModel.attachmentImage {
            let attachment = NSTextAttachment()
            attachment.image = attachmentImage
            let imagedAttributedString = NSAttributedString(attachment: attachment)
            fullAttributedString.append(imagedAttributedString)
        }

        label.attributedText = fullAttributedString
        button.setTitle(viewModel.buttonTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

