//
//  ListSupplementaryHeader.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/3/20.
//  Copyright © 2020 Jayesh Kawli. All rights reserved.
//

import UIKit

class ListSupplementaryHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "list-supplementary-header-reusable-view"
    let label = UILabel()

    enum Constants {
        static let padding: CGFloat = 10.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .orange
        addSubview(label)
        
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


