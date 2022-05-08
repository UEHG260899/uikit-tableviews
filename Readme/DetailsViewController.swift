//
//  DetailsViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    let book: Book
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = book.title
        authorLabel.text = book.author
        bookImage.image = book.image
        bookImage.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called")
    }
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
    
    @IBAction func updateImage(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
        ? .camera
        : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }


}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        bookImage.image = selectedImage
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true, completion: nil)
    }
}
