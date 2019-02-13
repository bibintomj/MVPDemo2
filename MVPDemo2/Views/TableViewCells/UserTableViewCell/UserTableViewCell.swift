//
//  UserTableViewCell.swift
//  MVPDemo2
//
//  Created by Bibin on 08/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

/// TableViewcell to display a user details
class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    /// Presenter for the cell; Refreshed the data whenever presenter is set
    var presenter = UserTableViewCellPresenter() {
        didSet {
            self.reset()
            self.configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter.attach(view: self)
        
        self.reset()
    }
    
    /// Populates details of user to the cell
    func configure() {
        self.titleLabel.text = presenter.user?.name.full.capitalized ?? ""
        self.subtitleLabel.text = presenter.user?.phone ?? ""
        let imageURL = presenter.user?.imageURL.thumbnail ?? ""
        
        // Downloads the image if not already available.
        if presenter.user?.image == nil {
            thumbnailImageView.load(url: URL(string: imageURL)!) { (image) in
                self.presenter.user?.image = image
            }
        }
        else {
            thumbnailImageView.image = presenter.user?.image
        }
    }
    
    
    // Resets the cell UI by removing User's details.
    func reset() {
        self.borderView.layer.cornerRadius = 10
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor.white.cgColor
        
        self.thumbnailImageView.image = #imageLiteral(resourceName: "Contact")
        self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.height / 2
        self.thumbnailImageView.layer.borderWidth = 2
        self.thumbnailImageView.layer.borderColor = UIColor.white.cgColor
        self.thumbnailImageView.clipsToBounds = true
        
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
    }
}

extension UserTableViewCell: BaseView {
    func showProgress() {}
    
    func hideProgress() {}
}
