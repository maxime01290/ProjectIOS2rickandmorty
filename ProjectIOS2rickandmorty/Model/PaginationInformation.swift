//
//  PaginationInformation.swift
//  ProjectIOS2rickandmorty
//
//  Created by lpiem on 24/02/2021.
//

import Foundation

/*
 {
     "count": 671,
     "pages": 34,
     "next": "https://rickandmortyapi.com/api/character?page=2",
     "prev": null
 }
 */

struct PaginationInformation {
    let count: Int
    let pages: Int
    let nextURL: URL?
    let previousURL: URL?
}

extension PaginationInformation: Decodable {
    enum CodingKeys: String, CodingKey {
        case count
        case pages
        case nextURL = "next"
        case previousURL = "prev"
    }
}
