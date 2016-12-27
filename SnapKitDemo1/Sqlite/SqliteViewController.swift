//
//  SqliteViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/22.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

struct Language {
    let name: String
    let version: Double
    func dd_print() {
        print("name: \(name), version: \(version)")
    }
}

class SqliteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        let language = Language.init(name: "Swift", version: 3.0)
        let amirror = Mirror.init(reflecting: language)
        print("subjectType: \(amirror.subjectType),\ndisplayStyle: \(amirror.displayStyle),\nsuperclassMirror: \(amirror.superclassMirror)")
        print("Type is \(amirror.subjectType)")
        amirror.children.forEach { (child) in
            print("label: \(child.label!), value: \(child.value)")
        }
    }
}
