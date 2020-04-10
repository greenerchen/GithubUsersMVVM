//
//  SearchUserIdealCell.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveSwift

class SearchUserIdealCell: SearchUserBaseCell {

    @IBOutlet weak var avatarImageView: SDAnimatedImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        usernameLabel.text = "Loading..."
        screenNameLabel.text = "Loading..."
        locationImage.isHidden = true
        locationLabel.isHidden = true
    }
    
    override func set(model: SearchUserCellModel) {
        super.set(model: model)
    }
    
    override func bind() {
        viewModel!.user.producer.skipNil().startWithValues({ [unowned self] (user) in
            DispatchQueue.main.async {
                self.usernameLabel.text = user.username
                self.screenNameLabel.text = user.screenName
                if let avatarUrl = user.avatarUrl {
                    self.avatarImageView.sd_setImage(with: URL(string: avatarUrl))
                }
                if let location = user.location {
                    self.locationImage.isHidden = false
                    self.locationLabel.isHidden = false
                    self.locationLabel.text = location
                }
                self.repositoryLabel.text = "\(user.publicRepos)"
                self.followersLabel.text = "\(user.followers)"
                self.followingLabel.text = "\(user.following)"
            }
        })
        
    }
}
