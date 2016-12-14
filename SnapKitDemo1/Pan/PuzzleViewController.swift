//
//  PuzzleViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/13.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        let puzzle = PuzzleView()
        self.view.addSubview(puzzle)
        puzzle.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
