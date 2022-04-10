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
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            allIngridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
        
        fetchRequest.predicate = NSPredicate(format: "added = true")
        
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
        
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "added = true")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            return try context.fetch(fetchRequest).count
            //curIngridients.sort(by: { $0.name! < $1.name! })

        } catch {
            return 0
        }
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
            self.deleteRow(inTableview: curIngridientIndex)
            }
        return deleteAction
    }
    
      override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.deleteIngrid(rowIndexPathAt: indexPath)
        delete.backgroundColor = UIColor.red
        let swipe = UISwipeActionsConfiguration(actions: [delete])

        
        return swipe
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory" {
            let dvc = segue.destination as! CategoryIngridViewController
            dvc.curIngridientsArray = curIngridients
            dvc.delegate = self
        }
    }
}

extension IngredientsViewController: DeleteRowInTableviewDelegate {
  func deleteRow(inTableview curIngridientIndex: Int) {
      
      let indexPath = IndexPath(row: curIngridientIndex, section: 0)
      let curIngridient = self.curIngridients[curIngridientIndex]
      let normalIndex = self.allIngridients.firstIndex{$0 === curIngridient}!
      self.curIngridients.remove(at: curIngridientIndex)
      self.allIngridients[normalIndex].added = false
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      do {
          try self.context.save()
      } catch let error as NSError {
          print("no save: \(error)")
      }
      
  }
}

