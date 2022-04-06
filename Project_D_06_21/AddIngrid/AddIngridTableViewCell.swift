//
//  AddIngridTableViewCell.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 09.07.2021.
//

import UIKit

protocol AddIngridCellDelegator {
    func callSegueFromCell(myData dataobject: UIButton)
}

class AddIngridTableViewCell: UITableViewCell {

    var delegate: AddIngridCellDelegator!
    
    @IBOutlet weak var addIngrigNameLabel: UILabel!
    @IBOutlet weak var addIngridInfoButton: UIButton!
    @IBOutlet weak var addIngridButton: UIButton!
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        addIngridInfoButton.tag = addIngridButton.tag
        if(self.delegate != nil) {
            self.delegate.callSegueFromCell(myData: addIngridInfoButton)
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
