//
//  TableViewManager.swift
//  Pagination+UITableView
//
//  Created by Igor on 24.11.2021.
//

import UIKit

final class MainTableViewManager: NSObject {
    
    public var uploadMore: ((_ newPage: Int) -> Void)?
    
    private let tableView: UITableView
    private let loadingView: LoadingView
    private let loadMoreErrorView: LoadMoreErrorView
    private let placeholderView: PlaceholderView
    
    private var cellModels: [FeedModel.Hint] = []
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var isLoadingMore = false
    
    
    init(tableView: UITableView, loadingView: LoadingView, loadMoreErrorView: LoadMoreErrorView, placeholderView: PlaceholderView) {
        self.tableView = tableView
        self.loadingView = loadingView
        self.loadMoreErrorView = loadMoreErrorView
        self.placeholderView = placeholderView
    }
    
    
    func set(cellModels: [FeedModel.Hint]) {
        self.cellModels = cellModels
    }
    
    func insert(newCellModels: [FeedModel.Hint]) {
        
        newCellModels.forEach {
            cellModels.append($0)
            
            let count = cellModels.count
            let row = count - 1
            let section = tableView.numberOfSections - 1
            let indexPath = IndexPath(row: row, section: section)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func set(totalPages: Int) {
        self.totalPages = totalPages
    }
    
    func set(currentPage: Int) {
        self.currentPage = currentPage
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func set(isLoadingMore: Bool) {
        self.isLoadingMore = isLoadingMore
    }
    
    func showTableFooterView(state: CollectionFooterViewType) {
        
        switch state {
        case .none:
            tableView.tableFooterView = nil
        case .loadingMore:
            tableView.tableFooterView = loadingView
        case .loadingError:
            tableView.tableFooterView = loadMoreErrorView
        case .placeholder:
            tableView.tableFooterView = placeholderView
        }
        
    }
    
    enum CollectionFooterViewType {
        case none
        case placeholder
        case loadingMore
        case loadingError
    }
}


// MARK: - UITableViewDataSource

extension MainTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell {
            cell.configure(cellModel: cellModels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}


// MARK: - UITableViewDelegate

extension MainTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == cellModels.count - 1 {
            
            if currentPage < totalPages && !isLoadingMore {
                print("API Calling")
                isLoadingMore = true
                
                showTableFooterView(state: .loadingMore)
                
                let newPage = currentPage + 1
                
                uploadMore?(newPage)
            }
        }
    }
}
