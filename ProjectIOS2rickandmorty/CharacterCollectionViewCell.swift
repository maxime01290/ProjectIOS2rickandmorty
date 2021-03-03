//
//  CharacterCollectionViewCell.swift
//  ProjectIOS2rickandmorty
//
//  Created by lpiem on 24/02/2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "characterCollectionViewCell"
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    public func configure(characters: Characters){
        nameLabel.text = characters.name
        speciesLabel.text = characters.species
        loadImage(characters: characters)
    }
    
    private func loadImage(characters:Characters){
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: characters.imageURL) else{ return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    
}
