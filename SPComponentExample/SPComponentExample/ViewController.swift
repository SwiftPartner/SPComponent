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
import SPComponent

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let cellID = "cellID"
    private weak var tableView: UITableView?
    private var numberOfRows = 20
    private var refreshControl: SPComponent.SPPullToRefreshControl<UITableView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPullToRefresh()
        setupDecorationView()
    }
    
    func doRefreshWork(isRefresh: Bool) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {[unowned self] in
            DispatchQueue.main.sync {
                if isRefresh {
                    self.numberOfRows = 0
//                    self.tableView?.mj_footer.isHidden = false
//                    self.tableView?.mj_header.endRefreshing()
//                    self.tableView?.reloadData()
                    print("数据刷新成功")
                } else {
                    self.numberOfRows = self.numberOfRows + 10
                    print("加载了更多数据")
                }
                self.refreshControl?.loadDataCompleted(hasMoreData: self.numberOfRows != 0)
            }
        }
    }
    
    func setupPullToRefresh() {
        let pullTorefreshControll = SPComponent.SPPullToRefreshControl<UITableView>(scrollView: self.tableView!)
        self.refreshControl = pullTorefreshControll
        self.refreshControl?.loadDataBlock = { [weak self] refreshType in
            switch refreshType {
            case .refresh:
                self?.doRefreshWork(isRefresh: true)
            case .loadMore:
                self?.doRefreshWork(isRefresh: false)
            }
        }
    }
    
    func setupTableView() {
        let tableView = UITableView()
        self.tableView = tableView
        tableView.backgroundColor = .red
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.bottom.equalTo(self.view)
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func setupDecorationView() {
        if #available(iOS 11.0, *) {
            let bottomView = UIView()
            bottomView.backgroundColor = .green
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { make in
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                make.bottom.equalTo(self.view)
            }
            
            let topView = UIView()
            topView.backgroundColor = .yellow
            view.addSubview(topView)
            topView.snp.makeConstraints { make in
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.view)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
}

