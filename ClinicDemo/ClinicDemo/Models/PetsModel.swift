//
//  PetsModel.swift
//  ClinicDemo
//
//  Created by Nivrutti on 12/08/22.
//

import Foundation


// MARK: - PetModel
struct PetModel: Decodable {
    let pets: [Pet]
}

// MARK: - Pet
struct Pet: Decodable {
    let imageURL: String
    let title: String
    let contentURL: String
    let dateAdded: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case title
        case contentURL = "content_url"
        case dateAdded = "date_added"
    }
}
