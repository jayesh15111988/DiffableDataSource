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
        case simple
        case verticalTriSection
        case imageCarousel
        case tree
        case squareFamily
    }

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

    var classicAppleSequence: [Int] = []
    var advanced313VerticalSequence: [Int] = []
    var imageSliderSequence: [Int] = []
    var complex1Sequence: [Int] = []
    var complex2PerfectSequence: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...20 {
            classicAppleSequence.append(i)
        }

        for i in 21...40 {
            advanced313VerticalSequence.append(i)
        }

        for i in 41...60 {
            imageSliderSequence.append(i)
        }

        for i in 61...80 {
            complex1Sequence.append(i)
        }

        for i in 81...100 {
            complex2PerfectSequence.append(i)
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
        collectionView.collectionViewLayout = createLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    func setupLayout() {
        let snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.simple, .verticalTriSection, .imageCarousel, .tree, .squareFamily])
        snapshot.appendItems(classicAppleSequence, toSection: .simple)
        snapshot.appendItems(advanced313VerticalSequence, toSection: .verticalTriSection)
        snapshot.appendItems(imageSliderSequence, toSection: .imageCarousel)
        snapshot.appendItems(complex1Sequence, toSection: .tree)
        snapshot.appendItems(complex2PerfectSequence, toSection: .squareFamily)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionViewController {

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            if sectionIndex == Section.simple.rawValue {
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
            } else if sectionIndex == Section.verticalTriSection.rawValue {
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
            } else if sectionIndex == Section.imageCarousel.rawValue {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 15.0)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                section.orthogonalScrollingBehavior = .paging
                return section
            } else if sectionIndex == Section.tree.rawValue {

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
            } else if sectionIndex == Section.squareFamily.rawValue {
                let topLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
                topLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let middleLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
                middleLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let middleLeadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)), subitems: [middleLeadingItem])

                let bottomLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
                bottomLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let bottomLeadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)), subitems: [bottomLeadingItem])

                let leftNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6667), heightDimension: .fractionalHeight(1.0)), subitems: [topLeadingItem, middleLeadingGroup, bottomLeadingGroup])

                let rightVerticalItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25)))
                rightVerticalItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                let rightNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3334), heightDimension: .fractionalHeight(1.0)), subitems: [rightVerticalItem])

                // 0.9*0.6667 + 0.9*0.6667 = 1.20006 total height of the container view
                let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.20006)), subitems: [leftNestedGroup, rightNestedGroup])

                let section = NSCollectionLayoutSection(group: nestedGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                return section
            }

            fatalError()
        }
        return layout
    }
}
