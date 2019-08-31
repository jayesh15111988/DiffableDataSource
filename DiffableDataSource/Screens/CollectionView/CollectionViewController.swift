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
        static let quickLinksFooterElementKind = "quick-links-footer-element-kind"
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
    var dataSource: UICollectionViewDiffableDataSource<AppSection, Int>!
    var mainSectionHeaderViewModels: [MainHeaderView.ViewModel] = []
    var subSectionHeaderViewModels: [SubHeaderView.ViewModel] = []

    var genericModels: [[Int]]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        var startIndex = 0
        for outerIndex in 0..<13 {
            genericModels.append([])
            let numberOfElementsToAdd = numberOfElements(in: AppSection(rawValue: outerIndex))
            for innerIndex in startIndex..<startIndex + numberOfElementsToAdd {
                genericModels[outerIndex].append(innerIndex)
            }
            startIndex = startIndex + 30
        }

        mainSectionHeaderViewModels.append(MainHeaderView.ViewModel(title: "Apps", image: UIImage(named: "profile")!.withRenderingMode(.alwaysTemplate), tintColor: UIColor.systemBlue))

        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Apps We Love Right Now", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Editor's Choice", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Top Free Apps", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Top Paid Apps", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Top Categories", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Our Favorite Subscriptions", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "School Essentials", buttonTitle: "See All", attachmentImage: UIImage(named: "school")))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Back to School Shopping", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Guided Meditation", buttonTitle: "See All", attachmentImage: nil))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Say It With a Sticker", buttonTitle: "See All", attachmentImage: UIImage(named: "chat")))
        subSectionHeaderViewModels.append(SubHeaderView.ViewModel(labelTitle: "Quick Links", buttonTitle: "", attachmentImage: nil))

        collectionView.register(NewUpdateCollectionViewCell.self, forCellWithReuseIdentifier: NewUpdateCollectionViewCell.reuseIdentifier)
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: Constants.mainHeaderElementKind, withReuseIdentifier: MainHeaderView.reuseIdentifier)
        collectionView.register(SubHeaderView.self, forSupplementaryViewOfKind: Constants.subHeaderElementKind, withReuseIdentifier: SubHeaderView.reuseIdentifier)
        collectionView.register(QuickLinksFooterView.self, forSupplementaryViewOfKind: Constants.quickLinksFooterElementKind, withReuseIdentifier: QuickLinksFooterView.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource
            <AppSection, Int>(collectionView: collectionView) {
                    (collectionView: UICollectionView, indexPath: IndexPath, sequence: Int) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewUpdateCollectionViewCell.reuseIdentifier, for: indexPath) as? NewUpdateCollectionViewCell else {
                        fatalError("Cannot create new cell of type NewUpdateCollectionViewCell") }
                cell.apply(viewModel: NewUpdateCollectionViewCell.ViewModel(topTitle: "", middleTitle: "\(sequence)", bottomTitle: "", image: nil))
                return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            if kind == Constants.mainHeaderElementKind {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainHeaderView.reuseIdentifier, for: indexPath) as? MainHeaderView {

                    guard let viewModel = self?.mainSectionHeaderViewModels[indexPath.section] else {
                        fatalError("Cannot get the valid view model to apply to given section. Unexpected condition encountered")
                    }
                    headerView.apply(viewModel: viewModel)
                    return headerView
                }
            } else if kind == Constants.subHeaderElementKind {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SubHeaderView.reuseIdentifier, for: indexPath) as? SubHeaderView {
                    guard let viewModel = self?.subSectionHeaderViewModels[indexPath.section - 1] else {
                        fatalError("Cannot get the valid view model to apply to given section. Unexpected condition encountered")
                    }
                    headerView.apply(viewModel: viewModel)
                    return headerView
                }
            } else if kind == Constants.quickLinksFooterElementKind {
                if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuickLinksFooterView.reuseIdentifier, for: indexPath) as? QuickLinksFooterView {
                    footerView.apply(viewModel: QuickLinksFooterView.ViewModel(leadingButtonTitle: "Redeem", trailingButtonTitle: "Send Gift"))
                    return footerView
                }
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
        setupDataSource()
    }

    private func numberOfElements(in section: AppSection?) -> Int {
        guard let section = section else { return 0 }
        switch section {
        case .topCategories, .quickLinks:
            return 6
        case .favoriteSubscriptions:
            return 2
        case .termsAndConditions:
            return 1
        default:
            return 30
        }
    }

    func setupDataSource() {
        let snapshot = NSDiffableDataSourceSnapshot<AppSection, Int>()
        snapshot.appendSections([.highlightedApps, .appsWeLove, .editorsChoice, .topFreeApps, .topPaidApps, .topCategories, .favoriteSubscriptions, .schoolEssentials, .backToSchoolShopping, .guidedMeditation, .sticker, .quickLinks, .termsAndConditions])

        snapshot.appendItems(genericModels[0], toSection: .highlightedApps)
        snapshot.appendItems(genericModels[1], toSection: .appsWeLove)
        snapshot.appendItems(genericModels[2], toSection: .editorsChoice)
        snapshot.appendItems(genericModels[3], toSection: .topFreeApps)
        snapshot.appendItems(genericModels[4], toSection: .topPaidApps)
        snapshot.appendItems(genericModels[5], toSection: .topCategories)
        snapshot.appendItems(genericModels[6], toSection: .favoriteSubscriptions)
        snapshot.appendItems(genericModels[7], toSection: .schoolEssentials)
        snapshot.appendItems(genericModels[8], toSection: .backToSchoolShopping)
        snapshot.appendItems(genericModels[9], toSection: .guidedMeditation)
        snapshot.appendItems(genericModels[10], toSection: .sticker)
        snapshot.appendItems(genericModels[11], toSection: .quickLinks)
        snapshot.appendItems(genericModels[12], toSection: .termsAndConditions)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedSequence = dataSource.itemIdentifier(for: indexPath) else { return }
        print("Selected Sequence is \(selectedSequence)")
    }
}

extension CollectionViewController {

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            if sectionIndex == AppSection.highlightedApps.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(300)), subitems: [item])

                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(64.0))

                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Constants.mainHeaderElementKind, alignment: .top)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [header]

                return section
            } else if sectionIndex == AppSection.appsWeLove.rawValue || sectionIndex == AppSection.schoolEssentials.rawValue || sectionIndex == AppSection.backToSchoolShopping.rawValue || sectionIndex == AppSection.guidedMeditation.rawValue || sectionIndex == AppSection.sticker.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .absolute(400)), subitem: item, count: 3)

                return self.configureAndReturnSectionForHeader(with: group)
            } else if sectionIndex == AppSection.editorsChoice.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .absolute(350)), subitem: item, count: 2)
                return self.configureAndReturnSectionForHeader(with: group)
            } else if sectionIndex == AppSection.topFreeApps.rawValue || sectionIndex == AppSection.topPaidApps.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .absolute(300)), subitem: item, count: 3)
                return self.configureAndReturnSectionForHeader(with: group)
            } else if sectionIndex == AppSection.topCategories.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .absolute(175)), subitem: item, count: 3)
                return self.configureAndReturnSectionForHeader(with: group)
            } else if sectionIndex == AppSection.favoriteSubscriptions.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .absolute(175)), subitems: [item])
                return self.configureAndReturnSectionForHeader(with: group)
            } else if sectionIndex == AppSection.quickLinks.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49), heightDimension: .absolute(175)), subitem: item, count: 3)
                let section = self.configureAndReturnSectionForHeader(with: group)

                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(94.0))

                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: Constants.quickLinksFooterElementKind, alignment: .bottom)

                section.boundarySupplementaryItems.append(footer)

                return section
            } else if sectionIndex == AppSection.termsAndConditions.rawValue {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(55)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                return section
            }

            fatalError()
        }
        return layout
    }

    private func configureAndReturnSectionForHeader(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: Constants.subHeaderElementKind, alignment: .top)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        return section
    }
}
