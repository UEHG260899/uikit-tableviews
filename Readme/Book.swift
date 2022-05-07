//
//  Book.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

struct Book {
    let title: String
    let author: String
    var image: UIImage {
        LibrarySymbol.letterSquare(letter: title.first).image
    }
}
