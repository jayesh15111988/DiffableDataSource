//
//  CollectionListViewCell.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/3/20.
//  Copyright © 2020 Jayesh Kawli. All rights reserved.
//

import UIKit

class MyCellCollectionViewListCell: UICollectionViewListCell {

    let label = UILabel()
    
    var item: Item?
    
    static let reuseIdentifier = "list-cell"

    enum Constants {
        static let padding: CGFloat = 10.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = .orange
        addSubview(label)
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.padding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            separatorLayoutGuide.leadingAnchor.constraint(equalTo: label.leadingAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = self.defaultContentConfiguration().updated(for: state)
        content.imageProperties.reservedLayoutSize = CGSize(width: 10, height: 44)
        let content1 = UIBackgroundConfiguration.listSidebarCell()
        //var content = UIListContentConfiguration.sidebarCell()
        
        content.text = item?.name
        content.image = item?.image
        
        if state.isHighlighted || state.isSelected {
            content.imageProperties.tintColor = .orange
            content.textProperties.color = .yellow
        }
        
        self.contentConfiguration = content
        self.backgroundConfiguration = content1
    }
    
}


