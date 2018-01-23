//
//  DetailViewController.swift
//  NetworkLayerForTest
//
//  Created by EVGENY Oborin on 23.01.2018.
//  Copyright © 2018 EVGENY Oborin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var gitRepository: GitRepository!
    
    //MARK: - Outlets
    
    @IBOutlet weak var repoIdLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoUrlLabel: UILabel!
    
    @IBOutlet weak var ownerLoginLabel: UILabel!
    @IBOutlet weak var ownerIdLabel: UILabel!
    @IBOutlet weak var ownerUrlLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let repo = gitRepository {
            setupViewsWithRepository(repo)
        }
    }
    
    //MARK: - Utilities

    func setupViewsWithRepository(_ repo: GitRepository) {
        repoIdLabel.text = String(repo.id)
        repoNameLabel.text = repo.fullName
        repoUrlLabel.text = repo.url ?? "no url"
        
        ownerLoginLabel.text = repo.owner.login
        ownerIdLabel.text = String(repo.owner.id)
        ownerUrlLabel.text = repo.owner.url
    }
}
