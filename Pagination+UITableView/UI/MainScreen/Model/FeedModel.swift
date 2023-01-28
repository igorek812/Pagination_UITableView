//
//  FeedModel.swift
//  Pagination+UITableView
//
//  Created by Igor on 30.11.2021.
//

import Foundation

struct FeedModel: Codable {
    let hits: [Hint]
    let nbPages: Int
}

extension FeedModel {
    
    struct Hint: Codable {
        let autor: String?
        let title: String
    }
}
