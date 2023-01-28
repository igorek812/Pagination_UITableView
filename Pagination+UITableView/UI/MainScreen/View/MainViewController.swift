//
//  ViewController.swift
//  Pagination+UITableView
//
//  Created by Igor on 24.11.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableViewManager: MainTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        setupTableView()
        fetchFeed(newPage: tableViewManager.getCurrentPage(), isLoadMore: false)
    }
}


// MARK: - Private

private extension MainViewController {
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "action", style: .plain, target: self, action: #selector(navBarRightAction))
    }
    
    @objc func navBarRightAction() {
        
        let vc = SecondViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableView() {
        
        let loadingView = LoadingView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
        let placeholderView = PlaceholderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let loadMoreErrorView = LoadMoreErrorView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100), resendButtonTapped: { [weak self] in
            guard let self = self else { return }
            
            self.tableViewManager.showTableFooterView(state: .loadingMore)
            self.fetchFeed(newPage: self.tableViewManager.getCurrentPage(), isLoadMore: true)
        })
        
        tableViewManager = MainTableViewManager(tableView: tableView, loadingView: loadingView, loadMoreErrorView: loadMoreErrorView, placeholderView: placeholderView)
        
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
        
        tableViewManager.uploadMore = { [weak self] newPage in
            self?.fetchFeed(newPage: newPage, isLoadMore: true)
        }
    }
    
    func fetchFeed(newPage: Int, isLoadMore: Bool) {
        
        NetworkService<FeedModel>().getData(newPage: newPage) { [weak self] result in
            
            switch result {
            case .success(let data):
                self?.fetchFeedHandle(data: data, newPage: newPage, isLoadMore: isLoadMore)
            case .failed(let error):
                self?.fetchFeedHandle(error: error, isLoadMore: isLoadMore)
            }
        }
    }
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


// MARK: - Network handle

extension MainViewController {
    
    func fetchFeedHandle(error: Error, isLoadMore: Bool) {
        
        if isLoadMore {
            tableViewManager.showTableFooterView(state: .loadingError)
        } else {
            showAlert(title: nil, message: error.localizedDescription)
        }
    }
    
    func fetchFeedHandle(data: FeedModel, newPage: Int, isLoadMore: Bool) {
        
        let totalPages = data.nbPages
        
        let cellModels: [FeedModel.Hint] = data.hits
        
        tableViewManager.set(currentPage: newPage)
        
        if isLoadMore {
            
            tableViewManager.insert(newCellModels: cellModels)
            tableViewManager.set(isLoadingMore: false)
            tableViewManager.showTableFooterView(state: .none)
            
        } else {
            
            if cellModels.isEmpty {
                
                tableViewManager.showTableFooterView(state: .placeholder)
                
            } else {
                tableViewManager.set(cellModels: cellModels)
                tableViewManager.set(totalPages: totalPages)
                tableViewManager.showTableFooterView(state: .none)
            }
            
            tableView.reloadData()
        }
    }
}
