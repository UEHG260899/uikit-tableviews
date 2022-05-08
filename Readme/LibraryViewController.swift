//
//  ViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

class LibraryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Library.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
            fatalError("Could not deque cell")
        }
        
        let book = Library.books[indexPath.row]
        cell.bookImage.image = book.image
        cell.bookImage.layer.cornerRadius = 12
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author

        return cell
        
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailsViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("No row selected")
        }
        
        let book = Library.books[indexPath.row]
        return DetailsViewController(coder: coder, book: book)
    }
    
}

