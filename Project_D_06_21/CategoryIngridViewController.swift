//
//  CategoryIngridViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 21.06.2021.
//

import UIKit

class CategoryIngridViewController: UITableViewController {
    
    let category = ["Все ингредиенты", "Мясо", "Птица", "Рыба и морепродукты", "Зелень", "Фрукты, ягоды", "Овощи", "Молочные продукты", "Бакалея", "Хлеб, мучное", "Специи, пряности и приправы", "Масло и соусы", "Напитки", "Сладкое", "Грибы"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        cell.textLabel?.text = self.category[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryIngrids" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! AddIngridViewController
                // print("seque")
                // print(indexPath.row)
                dvc.category = Int(indexPath.row)
            }
        }
    }



}
