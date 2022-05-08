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
    var review: String?
    
    var image: UIImage {
        Library.loadImage(forBook: self) ??
        LibrarySymbol.letterSquare(letter: title.first).image
    }
}
