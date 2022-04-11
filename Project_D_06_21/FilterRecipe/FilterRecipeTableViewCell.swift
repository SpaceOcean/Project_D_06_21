//
//  FilterRecipeTableViewCell.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 10.04.2022.
//

import UIKit

class FilterRecipeTableViewCell: UITableViewCell {
    
    let largeConfig = UIImage.SymbolConfiguration(scale: .large)
    var delegate: FilterRecipeDelegate?
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    @IBAction func checkboxTapped(_ sender: Any) {
        let rowIndex:Int = filterButton.tag
        switch rowIndex {
            case 0:
                if delegate?.filter.fullMatch ?? false {
                    filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                } else if !(delegate?.filter.fullMatch ?? true)  {
                    
                    filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                }
                delegate?.filter.fullMatch = !(delegate?.filter.fullMatch ?? true)
            
            case 1:
                if delegate?.filter.onlyMy ?? false {
                    filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                } else if !(delegate?.filter.onlyMy ?? true)  {
                    
                    filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                }
                delegate?.filter.onlyMy = !(delegate?.filter.onlyMy ?? true)
            
            case 2:
                if delegate?.filter.onlyFavorities ?? false {
                    filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                } else if !(delegate?.filter.onlyFavorities ?? true)  {
                    
                    filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                }
                delegate?.filter.onlyFavorities = !(delegate?.filter.onlyFavorities ?? true)
            default:
                print("error")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
