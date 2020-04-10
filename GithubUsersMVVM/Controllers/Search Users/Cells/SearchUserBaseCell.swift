//
//  SearchUserTemplateCell.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import UIKit

class SearchUserBaseCell: UICollectionViewCell {
    
    var viewModel: SearchUserCellModel? = nil {
        didSet {
            bind()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(model: SearchUserCellModel) {
        viewModel = model
    }
    
    func bind() {
        
    }
    
}

