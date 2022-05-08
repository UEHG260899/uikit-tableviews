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
    
    enum Section: String, CaseIterable {
        case addNew
        case readMe = "Read Me!"
        case finished = "Finished!"
    }
    

    var dataSource: UITableViewDiffableDataSource<Section, Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "HeaderView", bundle: .main),
            forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        configureDataSource()
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        updateDataSource()
    }

    
    // MARK: - DataSource
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 1 : Library.books.count
//    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        if indexPath == IndexPath(row: 0, section: 0) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
//            return cell
//        }
//
//
//
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
//            fatalError("Could not deque cell")
//        }
//
//        let book = Library.books[indexPath.row]
//        cell.bookImage.image = book.image
//        cell.bookImage.layer.cornerRadius = 12
//        cell.titleLabel.text = book.title
//        cell.authorLabel.text = book.author
//
//        return cell
//
//    }
    
    func configureDataSource()  {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, book -> UITableViewCell? in
            if indexPath == IndexPath(row: 0, section: 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
                fatalError()
            }
            
            cell.bookImage.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
            cell.bookImage.layer.cornerRadius = 12
            cell.titleLabel.text = book.title
            cell.authorLabel.text = book.author
            
            if let review = book.review {
                cell.reviewLabel.text = review
                cell.reviewLabel.isHidden = false
            }
            cell.readMeImage.isHidden = !book.readMe
            return cell
        }
    }
    
    func updateDataSource() {
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapshot.appendSections(Section.allCases)
        newSnapshot.appendItems(Library.books, toSection: .readMe)
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        
        for (readMe, books) in booksByReadMe {
            newSnapshot.appendItems(books, toSection: readMe ? .readMe : .finished)
        }
        
        newSnapshot.appendItems([Book.mockBook], toSection: .addNew)
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }
    
    // MARK: - Delegate

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = Section.allCases[section].rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailsViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let book = dataSource.itemIdentifier(for: indexPath) else {
            fatalError("No row selected")
        }
        
        return DetailsViewController(coder: coder, book: book)
    }
    
}

