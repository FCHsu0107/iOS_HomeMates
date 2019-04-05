//
//  MJRefreshWrapper.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        
        mj_header = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
    }
    
    func endHeaderRefreshing() {
        
        mj_header.endRefreshing()
    }
    
    func beginHeaderRefreshing() {
        
        mj_header.beginRefreshing()
    }
    
    func addRefreshFooter(refreshingBlock: @escaping () -> Void) {
        
        mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
    }
    
    func endFooterRefreshing() {
        
        mj_footer.endRefreshing()
    }
    
    func endWithNoMoreData() {
        
        mj_footer.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() {
        
        mj_footer.resetNoMoreData()
    }
    
    func removeHeaderRefresh() {
        
        mj_header = nil
        
        mj_footer = nil
    }
}
