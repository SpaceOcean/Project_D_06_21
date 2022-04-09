//
//  CategoryIngridViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 21.06.2021.
//

import UIKit

protocol DeleteRowInTableviewDelegate: NSObjectProtocol {
    func deleteRow(inTableview rowToDelete: Int)
}

class CategoryIngridViewController: UITableViewController {
    
    var curIngridientsArray: [Ingridient] = []
    var delegate: DeleteRowInTableviewDelegate?
    struct Category {
        let name: String
        let img: UIImage
        init(name: String, imageName: String) {
            self.name = name
            self.img = UIImage(named: imageName) ?? UIImage(named: "noPhoto.jpg")!
        }
    }
    let category = [Category(name: "Все ингредиенты", imageName: "allIngredients.jpg"),
                    Category(name: "Мясо", imageName: "meat.jpg"),
                    Category(name: "Птица", imageName: "bird.jpg"),
                    Category(name: "Рыба и морепродукты", imageName: "fish.jpg"),
                    Category(name: "Фрукты, ягоды", imageName: "fruits.jpg"),
                    Category(name: "Зелень", imageName: "greenery.jpg"),
                    Category(name: "Овощи", imageName: "vegetables.jpg"),
                    Category(name: "Молочные продукты", imageName: "milk.jpg"),
                    Category(name: "Бакалея", imageName: "grocery.jpg"),
                    Category(name: "Хлеб, мучное", imageName: "flour.jpg"),
                    Category(name: "Специи, пряности и приправы", imageName: "spices.jpg"),
                    Category(name: "Масло и соусы", imageName: "sauces.jpg"),
                    Category(name: "Напитки", imageName: "drinks.jpg"),
                    Category(name: "Сладкое", imageName: "dessert.jpg"),
                    Category(name: "Грибы", imageName: "mushrooms.jpg")]
                    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("delegate")
        print(delegate)
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! CategoryIngridTableViewCell
        
        let image = category[indexPath.row].img
        
        cell.categoryName.text = self.category[indexPath.row].name
        cell.categoryImg.image = image
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryIngrids" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! AddIngridViewController
                // print("seque")
                // print(indexPath.row)
                dvc.category = Int(indexPath.row)
                dvc.delegate = delegate
            }
        }
    }



}
