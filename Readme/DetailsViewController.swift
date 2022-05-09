//
//  DetailsViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

class DetailsViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var readMeButton: UIButton!
    
    var book: Book
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = book.title
        authorLabel.text = book.author
        bookImage.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
        bookImage.layer.cornerRadius = 12
        
        if let review = book.review {
            reviewTextView.text = review
        }
        
        reviewTextView.addDoneButton()
        
        let image = book.readMe
        ? LibrarySymbol.bookmarkFill.image
        : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
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
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        Library.update(book: book)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleReadMe(_ sender: UIButton) {
        book.readMe.toggle()
        let image = book.readMe
        ? LibrarySymbol.bookmarkFill.image
        : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        bookImage.image = selectedImage
        book.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        book.review = textView.text
        textView.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneButton() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolBar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolBar
    }
}
