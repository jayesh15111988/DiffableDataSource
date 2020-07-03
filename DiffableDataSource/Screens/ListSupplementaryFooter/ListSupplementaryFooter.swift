//
//  ListSupplementaryFooter.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/3/20.
//  Copyright © 2020 Jayesh Kawli. All rights reserved.
//

import UIKit

class ListSupplementaryFooterView: UICollectionReusableView {

    static let reuseIdentifier = "list-supplementary-footer-reusable-view"

    let label = UILabel()

    enum Constants {
        static let padding: CGFloat = 10.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        label.backgroundColor = .gray
        label.numberOfLines = 0
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
            
        clipsToBounds = true
        layer.cornerRadius = 10.0

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

