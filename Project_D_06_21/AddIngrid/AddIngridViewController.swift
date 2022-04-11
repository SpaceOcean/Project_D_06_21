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
    
    
    var infoIngridItem: Ingridient = Ingridient()
    
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell") as! AddIngridTableViewCell
        print("IngridientCell")
        print(ingridients.count)
        cell.addIngrigNameLabel.text = ingridients[indexPath.row].name
        cell.addIngridButton.tag = indexPath.row
        cell.addIngridButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
//        cell.addIngridButton.tag = indexPath.row
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        if ingridients[indexPath.row].added {
            cell.addIngridButton.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: largeConfig), for: .normal)
        } else {
            cell.addIngridButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: largeConfig), for: .normal)
        }
        
        
        cell.delegate = self
        
        return cell
    }


    @objc func addButtonTapped(sender: UIButton) {
        let fetchRequest: NSFetchRequest<Ingridient>  = Ingridient.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
        
        
        let rowIndex:Int = sender.tag
        let normalIndex = allIngridients.firstIndex{$0 === ingridients[rowIndex]}!
        

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
        
        print("Int(rectOfCellInSuperview.origin.y)")
        print(rowIndex)
        
        
        table.reloadData()
    }

    
    func callSegueFromCell(myData ingridID: UIButton) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        

        
        self.performSegue(withIdentifier: "Modify", sender: ingridID )

        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Modify" {
            let ingridButton = sender!
            let ingridID = (ingridButton as! UIButton).tag
            let dvc = segue.destination as! ModifyIngridientViewController
            dvc.ingridItem = ingridients[ingridID]
        }
    }
    
    
}
 
