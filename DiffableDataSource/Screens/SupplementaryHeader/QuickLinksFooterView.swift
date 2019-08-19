//
//  QuickLinksFooterView.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/18/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class QuickLinksFooterView: UICollectionReusableView {

    struct ViewModel {
        let leadingButtonTitle: String
        let trailingButtonTitle: String
    }

    static let reuseIdentifier = "quick-links-footer-reusable-view"
    let leadingButton: UIButton
    let trailingButton: UIButton

    override init(frame: CGRect) {

        leadingButton = UIButton()
        trailingButton = UIButton()

        leadingButton.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        trailingButton.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)

        leadingButton.clipsToBounds = true
        trailingButton.clipsToBounds = true

        leadingButton.layer.cornerRadius = 6.0
        trailingButton.layer.cornerRadius = 6.0

        leadingButton.setTitleColor(UIColor.systemBlue, for: .normal)
        trailingButton.setTitleColor(UIColor.systemBlue, for: .normal)

        leadingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        trailingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)

        super.init(frame: .zero)
        addSubview(leadingButton)
        addSubview(trailingButton)
        leadingButton.translatesAutoresizingMaskIntoConstraints = false
        trailingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            leadingButton.trailingAnchor.constraint(equalTo: trailingButton.leadingAnchor, constant: -Constants.horizontalPadding),
            trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            leadingButton.topAnchor.constraint(equalTo: topAnchor, constant: 2 * Constants.verticalPadding),
            leadingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3 * Constants.verticalPadding),
            trailingButton.topAnchor.constraint(equalTo: leadingButton.topAnchor),
            trailingButton.bottomAnchor.constraint(equalTo: leadingButton.bottomAnchor),
            leadingButton.widthAnchor.constraint(equalTo: trailingButton.widthAnchor, multiplier: 1.0)
            ])
    }

    func apply(viewModel: QuickLinksFooterView.ViewModel) {
        leadingButton.setTitle(viewModel.leadingButtonTitle, for: .normal)
        trailingButton.setTitle(viewModel.trailingButtonTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

