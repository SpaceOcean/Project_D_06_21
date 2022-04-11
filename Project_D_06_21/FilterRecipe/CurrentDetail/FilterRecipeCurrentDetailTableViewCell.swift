//
//  FilterRecipeCurrentDetailTableViewCell.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 11.04.2022.
//

import UIKit

class FilterRecipeCurrentDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var filterCheckbox: UIButton!
    @IBOutlet weak var filterName: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
