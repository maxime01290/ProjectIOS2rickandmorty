//
//  Characters.swift
//  ProjectIOS2rickandmorty
//
//  Created by lpiem on 24/02/2021.
//

import Foundation


struct Characters: Hashable {
    let identifier: Int
    let name: String
    let imageURL: URL
    let createdDate: Date
    let species:String
    let gender:String
    let status:String
}

extension Characters: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
        case imageURL = "image"
        case createdDate = "created"
        case species = "species"
        case gender = "gender"
        case status = "status"
    }
}
