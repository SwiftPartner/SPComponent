//
//  ViewController.swift
//  SPComponentExample
//
//  Created by ryan on 2018/10/30.
//  Copyright © 2018 bechoed. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
    }
    
    
}

