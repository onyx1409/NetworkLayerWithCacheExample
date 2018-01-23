//
//  ViewController.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 22.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposService = PublicReposCachedService(withCacheStore: PublicReposCoreDataStore(), apiStore: PublicReposAPI())
        loadData()
    }
    
    //MARK: - Data loading

    var reposService: PublicReposCachedService!
    
    var reposData = [GitRepository]()
    
    func loadData() {
        reposService.fetchRepos { [weak self] (repos, sourceType, error) in
            guard let sSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let title = sourceType.rawValue
            self?.navigationItem.title = title
            
            sSelf.reposData = repos
            sSelf.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposData.count
    }
    
    let cellReuseId = "basicCellID"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        configureCell(cell, forRow: indexPath.row)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forRow row: Int) {
        let repository = reposData[row]
        
        cell.textLabel?.text = repository.fullName
    }
    
    //MARK: - Navigation
    
    let detailSegueId = "detailVCSegueID"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId {
            
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let selectedRepository = reposData[selectedIndex.row]
            
            guard let detailVC = segue.destination as? DetailViewController else { return }
            detailVC.gitRepository = selectedRepository
        }
    }
}

