//
//  AddIngridViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 21.06.2021.
//

import UIKit
import CoreData

//protocol DeleteRowInTableviewDelegate: NSObjectProtocol {
//    func deleteRow(inTableview rowToDelete: Int)
//}



class AddIngridViewController: UITableViewController, AddIngridCellDelegator, NSFetchedResultsControllerDelegate {
    
    var delegate: DeleteRowInTableviewDelegate?
    
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    
    @IBOutlet var table: UITableView!
    var ingridients: [Ingridient] = []
    var allIngridients: [Ingridient] = []
    var curIngridients: [Ingridient] = []
    var category: Int = 0
    private var filteredCurIngridients: [Ingridient] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    var infoIngridItem: Ingridient = Ingridient()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Ingridient>  = Ingridient.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            allIngridients = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        print("allIngridients")
//        print(allIngridients)

        if (category != 0) {
            let format = "category == " + String(category - 1)
            fetchRequest.predicate = NSPredicate(format: format)
        }
        do {
            ingridients = try context.fetch(fetchRequest)
            // ingridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        curIngridients.remove(at: 0)
        print("qwertyuiop")
        
        
    
        
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Закрыть", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCurIngridients.count
        }
        return ingridients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var ingrid: Ingridient
        if isFiltering {
            ingrid = filteredCurIngridients[indexPath.row]
        } else {
            ingrid = ingridients[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell") as! AddIngridTableViewCell

        cell.addIngrigNameLabel.text = ingrid.name
        cell.addIngridButton.tag = indexPath.row
        cell.addIngridButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
//        cell.addIngridButton.tag = indexPath.row
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        if ingrid.added {
            cell.addIngridButton.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: largeConfig), for: .normal)
        } else {
            cell.addIngridButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
        }
        
        
        cell.delegate = self
        
        return cell
    }


    @objc func addButtonTapped(sender: UIButton) {
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "added = true")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            curIngridients = fetchedResultsController.fetchedObjects!
            curIngridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
        
        let rowIndex:Int = sender.tag
        let normalIndex: Int
        
        if isFiltering {
            normalIndex = allIngridients.firstIndex{$0 === filteredCurIngridients[rowIndex]}!
        } else {
            normalIndex = allIngridients.firstIndex{$0 === ingridients[rowIndex]}!
        }

//        self.allIngridients[normalIndex].added = !self.allIngridients[normalIndex].added
        if self.allIngridients[normalIndex].added {
            print("deleeetyertetee")
            delegate?.deleteRow(inTableview: self.curIngridients.firstIndex{$0 === self.allIngridients[normalIndex]}!)
        } else {
            self.allIngridients[normalIndex].added = true
            
            do {
                try context.save()
            } catch let error as NSError {
                print("no save: \(error)")
            }
        }
        
        table.reloadData()
    }

    
    func callSegueFromCell(myData ingridID: UIButton) {
        self.performSegue(withIdentifier: "Modify", sender: ingridID )
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Modify" {
            var ingrid: Ingridient
            
            let ingridButton = sender!
            let ingridID = (ingridButton as! UIButton).tag
            let dvc = segue.destination as! ModifyIngridientViewController
            
            if isFiltering {
                ingrid = filteredCurIngridients[ingridID]
            } else {
                ingrid = ingridients[ingridID]
            }
            dvc.ingridItem = ingrid
        }
    }
}
 
extension AddIngridViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCurIngridients = ingridients.filter({ (ingrid: Ingridient) -> Bool in
            return ingrid.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        table.reloadData()
    }
}
