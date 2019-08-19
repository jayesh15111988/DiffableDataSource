//
//  SupplementaryHeaderView.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/6/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class MainHeaderView: UICollectionReusableView {

    struct ViewModel {
        let title: String
        let image: UIImage
        let tintColor: UIColor
    }

    static let reuseIdentifier = "main-header-reusable-view"
    let label: UILabel
    let imageView: UIImageView

    override init(frame: CGRect) {
        label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38.0)
        imageView = UIImageView()
        super.init(frame: .zero)
        addSubview(label)
        addSubview(imageView)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -Constants.horizontalPadding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.profileImageSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.profileImageSize)
            ])
    }

    func apply(viewModel: MainHeaderView.ViewModel) {
        label.text = viewModel.title
        imageView.image = viewModel.image
        imageView.tintColor = viewModel.tintColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
