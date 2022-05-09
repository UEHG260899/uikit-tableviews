//
//  ViewController.swift
//  Readme
//
//  Created by Uriel Hernandez Gonzalez on 07/05/22.
//

import UIKit

enum SortStyle {
    case author
    case title
    case readMe
}

enum Section: String, CaseIterable {
    case addNew
    case readMe = "Read Me!"
    case finished = "Finished!"
}


class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = "\(LibraryHeaderView.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
}

class LibraryViewController: UITableViewController {
    
    
    @IBOutlet var sortButtons: [UIBarButtonItem]!
    
    
    var dataSource: LibraryDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "HeaderView", bundle: .main),
            forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        configureDataSource()
        dataSource.update(sortStyle: .readMe)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.update(sortStyle: dataSource.currentSortStyle)
    }

    
    func configureDataSource()  {
        dataSource = LibraryDataSource(tableView: tableView) { tableView, indexPath, book -> UITableViewCell? in
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
    
    
    @IBAction func sortByTitle(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .title)
        updateTintColors(tappedButton: sender)
    }
    @IBAction func sortByAuthor(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .author)
        updateTintColors(tappedButton: sender)
    }
    @IBAction func sortByReadMe(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .readMe)
        updateTintColors(tappedButton: sender)
    }
    
    func updateTintColors(tappedButton: UIBarButtonItem) {
        sortButtons.forEach { button in
            button.tintColor = (button == tappedButton)
            ? button.customView?.tintColor
            : .secondaryLabel
        }
        
    }
    
}

class LibraryDataSource: UITableViewDiffableDataSource<Section, Book> {
    
    var currentSortStyle: SortStyle = .title
    
    func update(sortStyle: SortStyle, animatingDifferences: Bool = true) {
        
        currentSortStyle = sortStyle
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapshot.appendSections(Section.allCases)
        newSnapshot.appendItems(Library.books, toSection: .readMe)
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        
        for (readMe, books) in booksByReadMe {
            var sortedBooks: [Book]
            
            switch sortStyle {
            case .author:
                sortedBooks = books.sorted { $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending }
            case .title:
                sortedBooks = books.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            case .readMe:
                sortedBooks = books
            }
            newSnapshot.appendItems(sortedBooks, toSection: readMe ? .readMe : .finished)
        }
        
        newSnapshot.appendItems([Book.mockBook], toSection: .addNew)
        apply(newSnapshot, animatingDifferences: animatingDifferences)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == snapshot().indexOfSection(.addNew) ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let book = self.itemIdentifier(for: indexPath) else {
                return
            }
            
            Library.delete(book: book)
            update(sortStyle: currentSortStyle)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section != snapshot().indexOfSection(.readMe)
            || currentSortStyle == .readMe {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath,
              sourceIndexPath.section == destinationIndexPath.section,
              let bookToMove = itemIdentifier(for: sourceIndexPath),
              let bookAtDestination = itemIdentifier(for: destinationIndexPath) else {
                  apply(snapshot(), animatingDifferences: false)
                  return
              }
        
        Library.reorderBooks(bookToMove: bookToMove, bookAtDestination: bookAtDestination)
        update(sortStyle: currentSortStyle, animatingDifferences: false)
    }
}

