//
//  SearchUserEmptyCell.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import UIKit

class SearchUserEmptyCell: SearchUserBaseCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    override func set(model: SearchUserCellModel) {
        super.set(model: model)
    }
    
    override func bind() {
        descriptionLabel.text = viewModel!.emptyDescription ?? ""
    }
}
