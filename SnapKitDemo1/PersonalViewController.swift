//
//  PersonalViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/8.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    fileprivate let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.tableFooterView = UIView()
        return table
    }()
    
    fileprivate let headView: ScaleAvatar = {
        let head = ScaleAvatar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        return head
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBar(with: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBar(with: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(-64)
        }
    }
}

extension PersonalViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > -64 && offsetY < 0 {
            let abs = fabs(offsetY)
            let alpha = (64 - abs) / 64
            setNavigationBar(with: alpha)
        } else if offsetY <= -64 {
            setNavigationBar(with: 0)
        } else{
            setNavigationBar(with: 1)
        }
    }
    
    fileprivate func setNavigationBar(with alpha: CGFloat) {
//        let color = UIColor.ld_color(withHex: 0x28b6ea)
//        self.navigationController?.navigationBar.setBackgroundColor(color: color.withAlphaComponent(alpha))
        self.navigationController?.navigationBar.setOverlayAlpha(alpha: alpha)
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
