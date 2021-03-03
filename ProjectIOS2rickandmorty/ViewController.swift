//
//  ViewController.swift
//  ProjectIOS2rickandmorty
//
//  Created by lpiem on 24/02/2021.
//

import UIKit

class ViewController: UICollectionViewController {

    private var characterList:[Characters] = []
    
    private enum Section{
        case main
    }
    
    private enum Item: Hashable {
        case character(Characters)
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section,Item>!
    
    private func createSnapshot(characters: [Characters]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])

        let items = characters.map(Item.character)

        snapshot.appendItems(items, toSection: .main)

        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        //création de la liste
        collectionView.collectionViewLayout = createLayout()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (tableView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let characters):
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath) as! CharacterCollectionViewCell
                cell.configure(characters: characters)
                return cell
            }
        })

        let snapchot = createSnapshot(characters: [])
        diffableDataSource.apply(snapchot)
        
        loadData()
    }

    private func loadData(){
        //chargement des données du webService
        NetworkManager.shared.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                let characters = paginatedElements.decodedElements
                let snapshot = self.createSnapshot(characters: characters)
                self.characterList = characters
                DispatchQueue.main.async {
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
    
    private func createLayout()-> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            
            //rajouter
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }

        return layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsCharacterViewController,
           segue.identifier == "goToDetailCharacter" {

            guard let indexPath = collectionView.indexPath(for: sender as! CharacterCollectionViewCell),
                  let item = self.diffableDataSource.itemIdentifier(for: indexPath) else {
                return
            }
            
            switch item {
            case .character(let serieCharacter):
                destination.character = serieCharacter
            }
        }
    }
}
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        var isSearchBarEmpty: Bool{
            return searchQuery? .isEmpty ?? true
        }
        if(!isSearchBarEmpty){
            let array = self.characterList.filter { $0.name.localizedCaseInsensitiveContains(searchQuery!) }
            let snapshot = self.createSnapshot(characters: array)
            self.characterList = array
            DispatchQueue.main.async {
                self.diffableDataSource.apply(snapshot)
            }
        }else{
            loadData()
        }
    }
}

