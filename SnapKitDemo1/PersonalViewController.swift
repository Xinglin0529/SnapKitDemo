//
//  PersonalViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/8.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    fileprivate let customNavigationBar: UIView = {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
            v.backgroundColor = .green
        return v
    }()
    
    fileprivate let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.tableFooterView = UIView()
        return table
    }()
    
    fileprivate let headView: ScaleAvatar = {
        let head = ScaleAvatar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        return head
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let view: UIView = (self.navigationController?.navigationBar.subviews.first)!
        view.addSubview(customNavigationBar)
    }
}

extension PersonalViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > -64 && offsetY < 0 {
            let abs = fabs(offsetY)
            customNavigationBar.alpha = (64 - abs) / 64
        } else if offsetY <= -64 {
            self.customNavigationBar.alpha = 0
        } else{
            self.customNavigationBar.alpha = 1
        }
    }
}

extension PersonalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "行数\(indexPath.row)"
        return cell
    }
}
