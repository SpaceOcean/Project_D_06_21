//

//  IngredientsViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//

import UIKit
import CoreData

class IngredientsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    var curIngridients: [Ingridient] = []
    var allIngridients: [Ingridient] = []
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - GET DATA FROM FILE
    
    func getDataFrom() {
        
        // print("getdtatatatatingrid")
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name != nil")
        // fetchRequest.delegate = self
        
        do {
            allIngridients = try context.fetch(fetchRequest)
            //allIngridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard records == 0 else {
            return
        }
    
        
        guard let pathToFile = Bundle.main.path(forResource: "normalIngrid", ofType: "plist") else {
            return
            
        }
        let dataArray = NSArray(contentsOfFile: pathToFile)!

        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Ingridient", in: context)
            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! Ingridient
            let ingridDictionary = dictionary as! [String : Any]
            ingrid.name = ingridDictionary["name"] as? String
            ingrid.index = ingridDictionary["index"] as? String
            ingrid.category = ingridDictionary["category"] as! Int32
            ingrid.added = false
        }
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFrom()
        
        
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "added = true")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            curIngridients = fetchedResultsController.fetchedObjects!
            curIngridients = try context.fetch(fetchRequest)
            //curIngridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    // MARK: - TABLE VIEW DATA SOURCE (UPDATE TABLE)
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = newIndexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = newIndexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        curIngridients = controller.fetchedObjects as! [Ingridient]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - TABLE VIEW CELL
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("test")
        return curIngridients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       cell.textLabel?.text = curIngridients[indexPath.row].name
       return cell
    }
    
    // MARK: - DELETE INGRIDIENT ACTION
    
    private func deleteIngrid(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить") {
         _, _, _ in
            
            let curIngridientIndex = indexPath.row
            let curIngridient = self.curIngridients[curIngridientIndex]
            let normalIndex = self.allIngridients.firstIndex{$0 === curIngridient}!
            self.curIngridients.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.allIngridients[normalIndex].added = false
            do {
                try self.context.save()
            } catch let error as NSError {
                print("no save: \(error)")
            }
        }
        return deleteAction
    }
    
      override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.deleteIngrid(rowIndexPathAt: indexPath)
        delete.backgroundColor = UIColor.red
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
      }
}

