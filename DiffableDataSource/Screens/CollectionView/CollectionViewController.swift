//
//  CollectionViewController.swift
//  DiffableDataSource
//
//  Created by Jayesh Kawli on 7/1/19.
//  Copyright © 2019 Jayesh Kawli. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {

    enum Constants {
        static let listHeaderElementKind = "list-header-element-kind"
        static let listFooterElementKind = "list-footer-element-kind"
    }
    
    enum Section: Int, CaseIterable {
        case rows
    }

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    var indicesWithChangedColor: Set<Int> = []

    var sequenceRowData: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Registering only for cells
        collectionView.register(MyCellCollectionViewListCell.self, forCellWithReuseIdentifier: "list-cell")
        
        // For List view cells header and footers
        collectionView.register(ListSupplementaryHeaderView.self, forSupplementaryViewOfKind: Constants.listHeaderElementKind, withReuseIdentifier: ListSupplementaryHeaderView.reuseIdentifier)
        collectionView.register(ListSupplementaryFooterView.self, forSupplementaryViewOfKind: Constants.listFooterElementKind, withReuseIdentifier: ListSupplementaryFooterView.reuseIdentifier)

        for i in 1...20 {
            sequenceRowData.append(i)
        }

        dataSource = UICollectionViewDiffableDataSource
            <Section, Int>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                number: Int) -> UICollectionViewCell? in

                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MyCellCollectionViewListCell.reuseIdentifier, for: indexPath) as? MyCellCollectionViewListCell else {
                    fatalError("Cannot create new cell") }

                let changeColorAction = UIContextualAction(style: .normal, title: "Change Color") { [weak self] (_, _, completion) in
                    guard let strongSelf = self else {
                        completion(false)
                        return
                    }
                    
                    strongSelf.changeColor(identifier: number)
                    completion(true)
                }

                cell.accessories = [
                    .outlineDisclosure(displayed: .always, options: .init(style: .automatic), actionHandler: {
                        print("Handling Disclosure Tap")
                    }),
                    .delete(displayed: .always, actionHandler: {
                        print("Handling Delete action")
                    })
                ]

                changeColorAction.backgroundColor = .black
                cell.leadingSwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [changeColorAction])
                cell.label.text = "\(number)"
                return cell
        }

        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if kind == UICollectionView.elementKindSectionHeader {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: Constants.listHeaderElementKind, withReuseIdentifier: ListSupplementaryHeaderView.reuseIdentifier, for: indexPath) as? ListSupplementaryHeaderView {
                    headerView.label.text = "List Header\nHeader\nHeader\nHeader"
                    return headerView
                }
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: Constants.listFooterElementKind, withReuseIdentifier: ListSupplementaryFooterView.reuseIdentifier, for: indexPath) as? ListSupplementaryFooterView {
                    footerView.label.text = "List Footer\nFooter\nFooter\nFooter"
                    return footerView
                }
            }

            // If you have an additional header-footer type for another section, please implement it here. If your section is registered to have header or footer and no such value is returned from this method, an application will crash
            fatalError("Failed to get expected supplementary reusable view from collection view. Stopping the program execution")
        }

        collectionView.collectionViewLayout = createLayout()
    }
    
    private func changeColor(identifier: Int) {
        if let indexPath = dataSource.indexPath(for: identifier) {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? MyCellCollectionViewListCell {
                if indicesWithChangedColor.contains(identifier) {
                    indicesWithChangedColor.remove(identifier)
                    cell.label.backgroundColor = .white
                } else {
                    indicesWithChangedColor.insert(identifier)
                    cell.label.backgroundColor = .red
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadData()
    }

    func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.rows])
        snapshot.appendItems(sequenceRowData, toSection: .rows)
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
            
            let section = self.customRowLayout(layoutEnvironment: layoutEnvironment)

            return section
        }
        return layout
    }
    
    private func customRowLayout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        configuration.footerMode = .supplementary
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        return section
        
        // MARK: Alternate way to assign header and footers to given list. This is better way of handling dynamic content in Header and Footer. It was observed that if we use built-in header and footer using lines of code 161-162, app will throw warnings for breaking constraints
//            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
//
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Constants.listHeaderElementKind, alignment: .top)
//            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Constants.footerElementKind, alignment: .bottom)
//            section.boundarySupplementaryItems = [header]
    }
}
