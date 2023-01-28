//
//  PlaceholderView.swift
//  Pagination+UITableView
//
//  Created by Igor on 30.11.2021.
//

import UIKit

final class PlaceholderView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Empty list"
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}
