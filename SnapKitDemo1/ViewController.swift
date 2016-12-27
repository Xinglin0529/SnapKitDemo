//
//  ViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/24.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import SnapKit

private let identifier = "UITableViewCell"

struct PushItem {
    var className: String
    var title: String
}

class ViewController: UIViewController {
    
    fileprivate let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.tableFooterView = UIView()
        return table
    }()
    
    fileprivate var dataList: [PushItem]!
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeItem = PushItem.init(className: "SwipeViewController", title: "Swipe")
        let personalItem = PushItem.init(className: "PersonalViewController", title: "Personal")
        let boardItem = PushItem.init(className: "BoardViewController", title: "Board")
        let panItem = PushItem.init(className: "PanViewController", title: "Pan")
        let puzzleItem = PushItem.init(className: "PuzzleViewController", title: "Puzzle")
        let editorItem = PushItem.init(className: "CollectionViewController", title: "EditorView")
        let sessionItem = PushItem.init(className: "URLSessionViewController", title: "URLSession")
        let sqliteItem = PushItem.init(className: "SqliteViewController", title: "Sqlite")
        dataList = [
            swipeItem,
            personalItem,
            boardItem,
            panItem,
            puzzleItem,
            editorItem,
            sessionItem,
            sqliteItem
        ]
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
//        gcdTest()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "show", style: .plain, target: self, action: #selector(ViewController.openNext))
    }
    
    func openNext() {
        if index == dataList.count - 1 {
            index = 0
        }
        let next = nextViewController(index)
        show(next)
        index += 1
    }
    
    private func show(_ next: UIViewController) {
        self.addChildViewController(next)
        next.view.frame = self.view.bounds
        self.view.addSubview(next.view)
        next.didMove(toParentViewController: self)
    }
    
    private func hide(content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    private func nextViewController(_ index: Int) -> UIViewController {
        let className = dataList[index].className
        let destinationClass: UIViewController.Type = className.toClass() as! UIViewController.Type
        return destinationClass.init()
    }
    
    func gcdTest() {
        print("current queue \(Thread.current), isMainThread \(Thread.isMainThread)")
        
        let time = DispatchTime.now() + 2
        
        DispatchQueue.main.asyncAfter(deadline: time) { 
            print("2秒之后调用")
        }
        
        let wallTime = DispatchWallTime.now() + 3
        
        DispatchQueue.main.asyncAfter(wallDeadline: wallTime) { 
            print("3秒之后调用")
        }
        
        let queue = DispatchQueue(label: "queue1")
        queue.async {
            print("queue1")
        }
        
        queue.sync {
            print("sync queue")
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                print("inner main queue")
            }
            
            print("global queue")
        }
        
//        DispatchQueue.main.sync {
//            print("同步执行")
//        }
        
        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent, target: nil)
        queue2.async {
            print("queue2 并行")
        }
        
        let group = DispatchGroup()
        let queue3 = DispatchQueue(label: "queue3")
        
        group.enter()
        DispatchQueue.main.async {
            print("main queue")
            group.leave()

        }
        queue3.async(group: group, execute: {

        })
        
        group.notify(queue: DispatchQueue.main) { 
            print("group task complete")
        }
        
        let queue5 = DispatchQueue(label: "workItem1")
        let workItem1 = DispatchWorkItem(qos: .userInitiated, flags: DispatchWorkItemFlags.assignCurrentContext, block: {
            print("workItem1 worked")
        })
        queue5.async(execute: workItem1)
        
    }
    
    func swap<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }
}

extension ViewController {
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let className = dataList[indexPath.row].className
        let destinationClass: UIViewController.Type = className.toClass() as! UIViewController.Type
        let controller = destinationClass.init()
        controller.title = dataList[indexPath.row].title
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = dataList[indexPath.row].title
        return cell
    }
}

