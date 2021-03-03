//
//  DetailsCharacterViewController.swift
//  ProjectIOS2rickandmorty
//
//  Created by lpiem on 03/03/2021.
//

import UIKit

class DetailsCharacterViewController: UIViewController {

    @IBOutlet weak private var labelName: UILabel!
    
    @IBOutlet weak private var image: UIImageView!
    
    @IBOutlet weak private var labelCreatedDate: UILabel!
    
    
    @IBOutlet weak private var labelSpeciesAndStatus: UILabel!
    
    @IBOutlet weak var labelGender: UILabel!
    
    var character: Characters?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let character = character{
            labelName.text = character.name
            let species = "Species : " + character.species
            let status = " Status : " + character.status
            labelSpeciesAndStatus.text = species + status
            labelGender.text = character.gender
            loadImage(characters: character)
            labelCreatedDate.text = DateFormatter.localizedString(from: character.createdDate, dateStyle: .medium, timeStyle: .short)
        }
        
    }
    
    private func loadImage(characters:Characters){
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: characters.imageURL) else{ return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image.image = image
            }
        }
    }

}
