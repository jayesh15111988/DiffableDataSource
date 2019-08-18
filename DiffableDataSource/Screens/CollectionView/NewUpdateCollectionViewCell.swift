//
//  NewUpdateCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 8/17/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

final class NewUpdateCollectionViewCell: UICollectionViewCell {

    struct ViewModel: Hashable {
        let topTitle: String
        let middleTitle: String
        let bottomTitle: String
        let image: UIImage
    }

    static let reuseIdentifier = "new-update-reusable-cell"

    let topTitleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.contentHorizontalAlignment = .left
        return button
    }()

    let middleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .black
        return label
    }()

    let bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .gray
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 6.0
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
        //setupViews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {

        contentView.addSubview(topTitleButton)
        contentView.addSubview(middleTitleLabel)
        contentView.addSubview(bottomTitleLabel)
        contentView.addSubview(imageView)

        topTitleButton.translatesAutoresizingMaskIntoConstraints = false
        middleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topTitleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPaddingSmall),
            middleTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPaddingSmall),
            bottomTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPaddingSmall),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPaddingSmall),
            topTitleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPaddingSmall),
            middleTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPaddingSmall),
            bottomTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPaddingSmall),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPaddingSmall),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0)
            ])

        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        topTitleButton.setContentHuggingPriority(.required, for: .vertical)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalPadding-[topTitleButton][middleTitleLabel][bottomTitleLabel]-[imageView]-verticalPadding-|", options: [], metrics: ["verticalPadding": Constants.verticalPadding], views: ["topTitleButton": topTitleButton, "middleTitleLabel": middleTitleLabel, "bottomTitleLabel": bottomTitleLabel, "imageView": imageView])
        self.addConstraints(verticalConstraints)
    }

    func apply(viewModel: NewUpdateCollectionViewCell.ViewModel) {
        topTitleButton.setTitle(viewModel.topTitle.capitalized, for: .normal)
        middleTitleLabel.text = viewModel.middleTitle
        bottomTitleLabel.text = viewModel.bottomTitle
        imageView.image = viewModel.image
    }
}
