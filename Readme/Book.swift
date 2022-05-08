//
//  Book.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

struct Book: Hashable {
    
    static let mockBook = Book(title: "", author: "", review: "", readMe: true)
    
    let title: String
    let author: String
    var review: String?
    var readMe: Bool
    
    var image: UIImage?
}


extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case review
        case readMe
    }
}
