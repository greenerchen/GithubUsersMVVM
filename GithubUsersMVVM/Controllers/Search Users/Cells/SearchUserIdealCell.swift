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
import ReactiveCocoa
import SkeletonView

class SearchUserIdealCell: SearchUserBaseCell {

    @IBOutlet weak var avatarImageView: SDAnimatedImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var repositoryIcon: UIImageView!
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var followersIcon: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingIcon: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = 5.0
        usernameLabel.text = ""
        screenNameLabel.text = ""
        locationLabel.text = ""
        
        avatarImageView.isSkeletonable = true
        avatarImageView.skeletonCornerRadius = 5.0
        usernameLabel.isSkeletonable = true
        usernameLabel.skeletonCornerRadius = 5.0
        screenNameLabel.isSkeletonable = true
        screenNameLabel.skeletonCornerRadius = 5.0
        locationImage.isSkeletonable = true
        locationImage.skeletonCornerRadius = 5.0
        locationLabel.isSkeletonable = true
        locationLabel.skeletonCornerRadius = 5.0
        repositoryIcon.isSkeletonable = true
        repositoryIcon.skeletonCornerRadius = 5.0
        repositoryLabel.isSkeletonable = true
        repositoryLabel.skeletonCornerRadius = 5.0
        followersIcon.isSkeletonable = true
        followersIcon.skeletonCornerRadius = 5.0
        followersLabel.isSkeletonable = true
        followersLabel.skeletonCornerRadius = 5.0
        followingIcon.isSkeletonable = true
        followingIcon.skeletonCornerRadius = 5.0
        followingLabel.isSkeletonable = true
        followingLabel.skeletonCornerRadius = 5.0
    }
    
    override func set(model: SearchUserCellModel) {
        showAllSkeletons()
        super.set(model: model)
    }
    
    override func bind() {
        viewModel!.displaySignal.observeValues { [unowned self] user in
            DispatchQueue.main.async {
                self.hideAllSkeletons()
                
                if let avatarUrl = user.avatarUrl {
                    self.avatarImageView.sd_setImage(with: URL(string: avatarUrl))
                }
                self.usernameLabel.text = user.username
                self.screenNameLabel.text = user.screenName
                
                self.locationImage.isHidden = user.location == nil
                self.locationLabel.isHidden = user.location == nil
                if let location = user.location {
                    self.locationLabel.text = location
                }
                self.repositoryLabel.text = "\(user.publicRepos)"
                self.followersLabel.text = "\(user.followers)"
                self.followingLabel.text = "\(user.following)"
                
            }
        }
    }
    
    private func showAllSkeletons() {
        avatarImageView.showAnimatedGradientSkeleton()
        usernameLabel.showAnimatedGradientSkeleton()
        screenNameLabel.showAnimatedGradientSkeleton()
        locationImage.showAnimatedGradientSkeleton()
        locationLabel.showAnimatedGradientSkeleton()
        repositoryIcon.showAnimatedGradientSkeleton()
        repositoryLabel.showAnimatedGradientSkeleton()
        followingIcon.showAnimatedGradientSkeleton()
        followingLabel.showAnimatedGradientSkeleton()
        followersIcon.showAnimatedGradientSkeleton()
        followersLabel.showAnimatedGradientSkeleton()
    }
    
    private func hideAllSkeletons() {
        avatarImageView.hideSkeleton()
        usernameLabel.hideSkeleton()
        screenNameLabel.hideSkeleton()
        locationImage.hideSkeleton()
        locationLabel.hideSkeleton()
        repositoryIcon.hideSkeleton()
        repositoryLabel.hideSkeleton()
        followingIcon.hideSkeleton()
        followingLabel.hideSkeleton()
        followersIcon.hideSkeleton()
        followersLabel.hideSkeleton()
    }
}
