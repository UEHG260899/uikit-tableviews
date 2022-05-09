//
//  AddBookTableViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

class AddBookTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var bookImage: UIImageView!
    
    var newBookImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImage.layer.cornerRadius = 12
        titleTextField.delegate = self
        authorTextField.delegate = self
    }



    @IBAction func addBookImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
        ? .camera
        : .photoLibrary
        present(picker, animated: true)
    }
    
    @IBAction func cancelCreation(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveNewBook(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
              let author = authorTextField.text,
              !title.isEmpty,
              !author.isEmpty else {
                  return
              }
        
        Library.addNew(book: Book(title: title, author: author, readMe: true, image: newBookImage))
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddBookTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        bookImage.image = selectedImage
        newBookImage = selectedImage
        picker.dismiss(animated: true)
    }
    
}


extension AddBookTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorTextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}
