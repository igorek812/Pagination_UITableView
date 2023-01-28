//
//  MainTableViewCell.swift
//  Pagination+UITableView
//
//  Created by Igor on 24.11.2021.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    public func configure(cellModel: FeedModel.Hint) {
        titleLabel.text = cellModel.title
    }
}
