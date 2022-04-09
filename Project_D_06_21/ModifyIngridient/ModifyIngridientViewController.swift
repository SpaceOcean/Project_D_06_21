//
//  ModifyIngridientViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 05.04.2022.
//

import UIKit

class ModifyIngridientViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var ingridItem: Ingridient = Ingridient()
    var newIngridWeight: Double = 1.0
    
    
    @IBOutlet weak var sliderWeight: UISlider!
    @IBOutlet weak var nameIngrid: UILabel!
    
    @IBAction func sliderWeightChanged(_ sender: Any) {
        self.newIngridWeight = Double(sliderWeight.value)
    }
    
    @IBAction func saveNewWeight(_ sender: Any) {
        ingridItem.weight = newIngridWeight
        do {
            try self.context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        showToast(message: "Данные изменены!", font: .systemFont(ofSize: 12.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameIngrid.text = "Ингредиент: \(ingridItem.name ?? "")"
        
        self.newIngridWeight = ingridItem.weight
        self.sliderWeight.value = Float(ingridItem.weight)
    }
    
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: 20, y: Int(self.view.frame.size.height) - 100, width: Int(self.view.frame.size.width) - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
