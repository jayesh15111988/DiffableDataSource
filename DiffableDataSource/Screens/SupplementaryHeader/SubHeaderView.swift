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
        let attachmentImage: UIImage
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

    func apply(viewModel: MainHeaderView.ViewModel) {
        label.text = viewModel.title
        button.setTitle(viewModel.title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

