//
//  SupplementaryView.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/5/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class BadgeSupplementaryView: UICollectionReusableView {

    let label: UILabel

    static let reuseIdentifier = "supplementary-view-reuse-identifier"

    override init(frame: CGRect) {
        label = UILabel(frame: .zero)
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        backgroundColor = .red
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11.0)

        layer.cornerRadius = 10.0
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
}
