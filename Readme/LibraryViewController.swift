//
//  ViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = "\(LibraryHeaderView.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
}

class LibraryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "HeaderView", bundle: .main),
            forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : Library.books.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
            return cell
        }
        
        
        
        
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = "Read Me!"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailsViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("No row selected")
        }
        
        let book = Library.books[indexPath.row]
        return DetailsViewController(coder: coder, book: book)
    }
    
}

