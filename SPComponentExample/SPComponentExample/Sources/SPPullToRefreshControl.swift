//
//  SPPullToRefreshControl.swift
//  SPComponentExample
//
//  Created by Ryan on 2018/11/1.
//  Copyright © 2018 bechoed. All rights reserved.
//

import UIKit
import MJRefresh

public class SPPullToRefreshControl<T: UIScrollView>  {
    
    public enum RefreshType {
        case refresh
        case loadMore
    }
    
    
    /// 下拉刷新以及上拉加载更多回掉
    public var loadDataBlock: ((RefreshType) -> Void)?
    
    private weak var scrollView: T?
    private var refreshType: RefreshType?
    
    init(scrollView: T,
         refreshHeader: MJRefreshStateHeader? = MJRefreshNormalHeader(),
         loadMoreFooter: MJRefreshAutoFooter? = MJRefreshAutoNormalFooter()) {
        
        self.scrollView = scrollView
        loadMoreFooter?.isHidden = true
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
        }
        if let tableView = scrollView as? UITableView {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        }
        scrollView.mj_header = refreshHeader
        scrollView.mj_footer = loadMoreFooter
        
        refreshHeader?.refreshingBlock = { [weak self] in
            print("开始刷新")
            loadMoreFooter?.isHidden = true
            self?.refreshType = .refresh
            self?.loadDataBlock?(.refresh)
        }
        loadMoreFooter?.refreshingBlock = { [weak self] in
            refreshHeader?.isHidden = true
            print("开始加载更多")
            self?.refreshType = .loadMore
            self?.loadDataBlock?(.loadMore)
        }
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        (refreshHeader as? MJRefreshNormalHeader)?.arrowView.isHidden = true
    }
    
    public func loadDataCompleted(hasMoreData: Bool = true) {
        guard let refreshType = refreshType else {
            return
        }
        switch refreshType {
        case .refresh:
            scrollView?.mj_footer.isHidden = false
            scrollView?.mj_header.endRefreshing()
            print("刷新完成")
        case .loadMore:
            print("加载完成")
            scrollView?.mj_header.isHidden = false
            if hasMoreData {
                scrollView?.mj_footer.endRefreshing()
            } else {
                scrollView?.mj_footer.endRefreshingWithNoMoreData()
            }
        }
        (scrollView as? UITableView)?.reloadData()
        (scrollView as? UICollectionView)?.reloadData()
    }
    
}
