//
//  SupplementaryFooterView.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/6/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class SupplementaryFooterView: UICollectionReusableView {

    static let reuseIdentifier = "supplementary-footer-reusable-view"

    let label: UILabel

    enum Constants {
        static let padding: CGFloat = 10.0
    }

    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: .zero)
        backgroundColor = .purple
        label.numberOfLines = 0
        label.backgroundColor = .red
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding),
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
