//
//  TableViewCell.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/1/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

class MyCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var customBackgroundView: UIView!

    override func awakeFromNib() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
}
