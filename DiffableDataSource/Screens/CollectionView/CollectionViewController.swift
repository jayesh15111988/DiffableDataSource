//
//  CollectionViewController.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/1/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {

    enum AppSection: Int, CaseIterable {
        case highlightedApps
        case appsWeLove
        case editorsChoice
        case topFreeApps
        case topPaidApps
        case topCategories
        case favoriteSubscriptions
        case schoolEssentials
        case backToSchoolShopping
        case guidedMeditation
        case sticker
        case quickLinks
        case termsAndConditions
    }

    enum Constants {
         static let mainHeaderElementKind = "main-header-element-kind"
         static let subHeaderElementKind = "sub-header-element-kind"
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
    var dataSource: UICollectionViewDiffableDataSource<AppSection, NewUpdateCollectionViewCell.ViewModel>!

    let newUpdatesViewModelsCollection = [
        NewUpdateCollectionViewCell.ViewModel(topTitle: "top title 1", middleTitle: "middle title 1", bottomTitle: "bottom title", image: UIImage(named: "add-to-cart-drawer-check")!),
        NewUpdateCollectionViewCell.ViewModel(topTitle: "top title 2", middleTitle: "middle title", bottomTitle: "bottom title", image: UIImage(named: "add-to-cart-drawer-check")!),
        NewUpdateCollectionViewCell.ViewModel(topTitle: "top title 3", middleTitle: "middle title", bottomTitle: "bottom title", image: UIImage(named: "add-to-cart-drawer-check")!),
        NewUpdateCollectionViewCell.ViewModel(topTitle: "top title 4", middleTitle: "middle title", bottomTitle: "bottom title", image: UIImage(named: "add-to-cart-drawer-check")!)]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(NewUpdateCollectionViewCell.self, forCellWithReuseIdentifier: NewUpdateCollectionViewCell.reuseIdentifier)
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: Constants.mainHeaderElementKind, withReuseIdentifier: MainHeaderView.reuseIdentifier)
        collectionView.register(SubHeaderView.self, forSupplementaryViewOfKind: Constants.subHeaderElementKind, withReuseIdentifier: SubHeaderView.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource
            <AppSection, NewUpdateCollectionViewCell.ViewModel>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, viewModel: NewUpdateCollectionViewCell.ViewModel) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewUpdateCollectionViewCell.reuseIdentifier, for: indexPath) as? NewUpdateCollectionViewCell else {
                        fatalError("Cannot create new cell") }

                cell.apply(viewModel: viewModel)
                return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainHeaderView.reuseIdentifier, for: indexPath) as? MainHeaderView {
                headerView.label.text = "Header\nHeader\nHeader\nHeader\n"
                return headerView
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
        let snapshot = NSDiffableDataSourceSnapshot<AppSection, NewUpdateCollectionViewCell.ViewModel>()
        snapshot.appendSections([.highlightedApps])
        snapshot.appendItems(newUpdatesViewModelsCollection, toSection: .highlightedApps)
//        snapshot.appendItems(classicAppleSequence, toSection: .classicApple)
//        snapshot.appendItems(advanced313VerticalSequence, toSection: .advanced313Vertical)
//        snapshot.appendItems(advanced313HorizontalSequence, toSection: .advanced313Horizontal)
//        snapshot.appendItems(imageSliderSequence, toSection: .imageSlider)
//        snapshot.appendItems(complex1Sequence, toSection: .complex1)
//        snapshot.appendItems(complex2ImperfectSequence, toSection: .complex2Imperfect)
//        snapshot.appendItems(complex2PerfectSequence, toSection: .complex2Perfect)
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

            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(300)), subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }
        return layout
    }
}
