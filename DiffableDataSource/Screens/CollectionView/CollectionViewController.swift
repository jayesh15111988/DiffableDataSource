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
    }

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    var countries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let countryNames = ["Afghanistan",
                            "Albania",
                            "Algeria",
                            "Andorra",
                            "Angola",
                            "Antigua and Barbuda",
                            "Argentina",
                            "Armenia",
                            "Australia",
                            "Austria",
                            "Azerbaijan",
                            "Bahamas",
                            "Bahrain",
                            "Bangladesh",
                            "Barbados",
                            "Belarus"]
        for name in countryNames {
            countries.append(Country(name: name))
        }

        dataSource = UICollectionViewDiffableDataSource
            <Section, Country>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                country: Country) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell", for: indexPath) as? MyCellCollectionViewCell else {
                        fatalError("Cannot create new cell") }
                cell.descriptionLabel.text = country.name
                let screenWidth = collectionView.frame.size.width
                cell.widthConstraint.constant = (screenWidth/2.0) - (2 * 16.0)
                return cell
        }
        performSearch(searchQuery: nil)
    }

    func performSearch(searchQuery: String?) {
        let filteredCountries: [Country]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            filteredCountries = countries.filter { $0.contains(query: searchQuery) }
        } else {
            filteredCountries = countries
        }
        let snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCountries, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
}
