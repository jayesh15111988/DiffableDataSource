//
//  CollectionViewController.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/1/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {

    enum Section: CaseIterable {
        case main
        case header
        case body
        case innerBody
    }

    enum Constants {
         static let badgeElementKind = "badge-element-kind"
         static let headerElementKind = "header-element-kind"
         static let footerElementKind = "footer-element-kind"
    }

    enum SectionLayoutKind: Int {
        case first
        case second
        case third
        case fourth

        func columnCount(width: CGFloat) -> Int {

            let wideMode = width > 600.0
            switch self {
            case .first:
                return wideMode ? 2: 1
            case .second:
                return wideMode ? 6 : 3
            case .third:
                return wideMode ? 10 : 5
            case .fourth:
                return 5
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var supplementaryDataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var sequence: [Int] = []
    var sequenceHeader: [Int] = []
    var sequenceBody: [Int] = []
    var sequenceInnerBody: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: Constants.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)

        collectionView.register(SupplementaryHeaderView.self, forSupplementaryViewOfKind: Constants.headerElementKind, withReuseIdentifier: SupplementaryHeaderView.reuseIdentifier)
        collectionView.register(SupplementaryFooterView.self, forSupplementaryViewOfKind: Constants.footerElementKind, withReuseIdentifier: SupplementaryFooterView.reuseIdentifier)

        for i in 1...10 {
            sequence.append(i)
        }

        for i in 11...30 {
            sequenceHeader.append(i)
        }

        for i in 31...50 {
            sequenceBody.append(i)
        }

        for i in 51...75 {
            sequenceInnerBody.append(i)
        }

        dataSource = UICollectionViewDiffableDataSource
            <Section, Int>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                number: Int) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell", for: indexPath) as? MyCellCollectionViewCell else {
                        fatalError("Cannot create new cell") }
                cell.headerLabel.text = nil
                cell.descriptionLabel.text = "\(number)"
                return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            if kind == Constants.headerElementKind {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryHeaderView.reuseIdentifier, for: indexPath) as? SupplementaryHeaderView {
                    headerView.label.text = "Header\nHeader\nHeader\nHeader\n"
                    return headerView
                }
            }

            if kind == Constants.footerElementKind {
                if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryFooterView.reuseIdentifier, for: indexPath) as? SupplementaryFooterView {
                    footerView.label.text = "Footer\nFooter\nFooter\nFooter\n"
                    return footerView
                }
            }

            guard let strongSelf = self, let sequence = strongSelf.dataSource.itemIdentifier(for: indexPath) else { return nil }
            if let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView {

                let badgeCount = sequence
                badgeView.label.text = "\(badgeCount)"
                badgeView.isHidden = false
                return badgeView
            }

            fatalError("Failed to get expected supplementary reusable view from collection view. Stopping the program execution")
        }

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //collectionView.collectionViewLayout = layout
        collectionView.collectionViewLayout = createLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performSearch(searchQuery: nil)
    }

    func performSearch(searchQuery: String?) {
        let snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main, .header, .body, .innerBody])
        snapshot.appendItems(sequence, toSection: .main)
        snapshot.appendItems(sequenceHeader, toSection: .header)
        snapshot.appendItems(sequenceBody, toSection: .body)
        snapshot.appendItems(sequenceInnerBody, toSection: .innerBody)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedSequence = dataSource.itemIdentifier(for: indexPath) else { return }
        print("Selected Sequence is \(selectedSequence)")
    }
}


extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
}

//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.size.width - 16.0, height: 64)
//    }
//}

extension CollectionViewController {
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 0.0, bottom: 5.0, trailing: 0.0)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(74.0))
//        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//        group.interItemSpacing = .fixed(10.0)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }

//    private func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
//            let columns = sectionLayoutKind.columnCount(width: layoutEnvironment.container.effectiveContentSize.width)
//
//            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
//            let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20.0), heightDimension: .absolute(20.0))
//            let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: Constants.badgeElementKind, containerAnchor: badgeAnchor)
//
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
//            item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
//
//            let groupHeight: NSCollectionLayoutDimension = columns == 1 ? .absolute(74) : .fractionalWidth(0.2)
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
//
//            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
//
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Constants.headerElementKind, alignment: .top)
//            header.pinToVisibleBounds = true
//
//            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Constants.footerElementKind, alignment: .bottom)
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
//            section.boundarySupplementaryItems = [header, footer]
//
//            return section
//        }
//
//        return layout
//    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 2)

            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.4)), subitems: [leadingItem, trailingGroup])

            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

            return section
        }
        return layout
    }
}
