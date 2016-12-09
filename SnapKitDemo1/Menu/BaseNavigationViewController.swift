//
//  BaseNavigationViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/9.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = .red
        UINavigationBar.appearance().barTintColor = UIColor.ld_color(withHex: 0x28b6ea)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.red
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
