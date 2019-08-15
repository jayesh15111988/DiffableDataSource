//
//  CollectionViewController.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/1/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case classicApple
        case advanced313Vertical
        case advanced313Horizontal
        case imageSlider
        // Ref: https://www.cocoacontrols.com/search?q=collectionviewlayout part 1, 2 and 3
        case complex1
        case complex2
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

    var classicAppleSequence: [Int] = []
    var advanced313VerticalSequence: [Int] = []
    var advanced313HorizontalSequence: [Int] = []
    var imageSliderSequence: [Int] = []
    var complex1Sequence: [Int] = []
    var complex2Sequence: [Int] = []
    var complex3Sequence: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: Constants.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)

        collectionView.register(SupplementaryHeaderView.self, forSupplementaryViewOfKind: Constants.headerElementKind, withReuseIdentifier: SupplementaryHeaderView.reuseIdentifier)
        collectionView.register(SupplementaryFooterView.self, forSupplementaryViewOfKind: Constants.footerElementKind, withReuseIdentifier: SupplementaryFooterView.reuseIdentifier)

        for i in 1...20 {
            classicAppleSequence.append(i)
        }

        for i in 21...40 {
            advanced313VerticalSequence.append(i)
        }

        for i in 41...60 {
            advanced313HorizontalSequence.append(i)
        }

        for i in 61...80 {
            imageSliderSequence.append(i)
        }

        for i in 81...100 {
            complex1Sequence.append(i)
        }

        for i in 101...120 {
            complex2Sequence.append(i)
        }

        for i in 121...140 {
            complex3Sequence.append(i)
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
        //snapshot.appendSections([.classicApple, .advanced313Vertical, .advanced313Horizontal, .imageSlider,.complex1, .complex2])
        snapshot.appendSections([.classicApple, .advanced313Vertical, .advanced313Horizontal, .imageSlider, .complex1, .complex2])
        snapshot.appendItems(classicAppleSequence, toSection: .classicApple)
        snapshot.appendItems(advanced313VerticalSequence, toSection: .advanced313Vertical)
        snapshot.appendItems(advanced313HorizontalSequence, toSection: .advanced313Horizontal)
        snapshot.appendItems(imageSliderSequence, toSection: .imageSlider)
        snapshot.appendItems(complex1Sequence, toSection: .complex1)
        snapshot.appendItems(complex2Sequence, toSection: .complex2)
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

            if sectionIndex == Section.classicApple.rawValue {
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 2)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.4)), subitems: [leadingItem, trailingGroup])

                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

                return section
            } else if sectionIndex == Section.advanced313Vertical.rawValue {
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)), subitem: leadingItem, count: 3)

                let middleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
                middleItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 3)

                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.5)), subitems: [leadingGroup, middleItem, trailingGroup])

                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

                return section
            } else if sectionIndex == Section.advanced313Horizontal.rawValue {
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let leadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)), subitem: leadingItem, count: 3)

                let middleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)))
                middleItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let trailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)), subitem: trailingItem, count: 3)

                let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.5)), subitems: [leadingGroup, middleItem, trailingGroup])

                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

                return section
            } else if sectionIndex == Section.imageSlider.rawValue {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 15.0)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                section.orthogonalScrollingBehavior = .paging
                return section
            } else if sectionIndex == Section.complex1.rawValue {

                // Top item
                let leadingTopItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                leadingTopItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                // Middle
                let leadingMiddleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
                leadingMiddleItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let leadingMiddleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25)), subitem: leadingMiddleItem, count: 2)

                // Bottom
                let leadingBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
                leadingBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let leadingBottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25)), subitem: leadingBottomItem, count: 2)

                let trailingBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                trailingBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let trailingFullGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0)), subitems: [leadingMiddleGroup, leadingBottomGroup, trailingBottomItem])

                let leadingFullGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0)), subitems: [leadingTopItem, leadingMiddleGroup, leadingBottomGroup])

                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.9)), subitems: [leadingFullGroup, trailingFullGroup])

                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                return section
            } else if sectionIndex == Section.complex2.rawValue {
                let topLeadingElement = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalHeight(1.0)))
                topLeadingElement.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let topTrailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                topTrailingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let topTrailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)), subitem: topTrailingItem, count: 2)

                let topNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(0.5)), subitems: [topLeadingElement, topTrailingGroup])

                let middleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
                middleItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let middleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(0.25)), subitems: [middleItem])

                let lastItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)))
                lastItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let lastGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(0.25)), subitems: [lastItem])

                let topTopNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.9)), subitems: [topNestedGroup, middleGroup, lastGroup])

                let section = NSCollectionLayoutSection(group: topTopNestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                return section
            }

            fatalError()
        }
        return layout
    }
}
