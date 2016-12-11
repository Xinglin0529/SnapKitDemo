//
//  BoardViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    private let segmentControl = UISegmentedControl.init(items: ["铅笔", "直线", "虚线", "矩形", "圆形", "橡皮擦"])
    private let board:Board = Board(frame: .zero)
    private let brushes = [PencilBrush(), LineBrush(), DashLineBrush(), RectangleBrush(), EllipseBrush(), EraserBrush()]
    private let toolBar = UIToolbar()
    private var selectedFont: Int = 0
    private var selectColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        addSegmentControl()
    }
    
    @objc private func switchSegment(seg: UISegmentedControl) {
        board.brush = brushes[seg.selectedSegmentIndex]
    }
    
    private func defaultSetting() {
        board.brush = brushes.first
    }
    
    private func addSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(BoardViewController.switchSegment(seg:)), for: .valueChanged)
        defaultSetting()
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.leading.equalTo(self.view).offset(20)
            make.trailing.equalTo(self.view).offset(-20)
            make.height.equalTo(36)
        }
        
        self.view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        self.view.addSubview(board)
        board.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(segmentControl.snp.bottom)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        let item1 = UIBarButtonItem.init(title: "画笔设置", style: .plain, target: self, action: #selector(BoardViewController.setBrush))
        let flexible1 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem.init(title: "背景设置", style: .plain, target: self, action: #selector(BoardViewController.setBackgroundImage))
        let flexible2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item3 = UIBarButtonItem.init(title: "保存到图库", style: .plain, target: self, action: #selector(BoardViewController.setBrush))
        toolBar.items = [item1, flexible1, item2, flexible2, item3]
    }
    
    @objc private func setBrush() {
        let b = SettingBrush.init(frame:CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 300), type: .brush(self.selectedFont, self.selectColor))
        b.completion = { [weak self] type in
            switch type {
            case .brush(let fontWeight, let color):
                self?.board.strokeColor = color!
                self?.board.strokeWidth = CGFloat(fontWeight)
                self?.selectedFont = fontWeight
                self?.selectColor = color!
            default:
                return
            }
        }
        DDPopManager.showActionSheet(withCustomView: b)
    }
    
    @objc private func setBackgroundImage() {
        let b = SettingBrush.init(frame:CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 220), type: .background(self.selectColor))
        b.completion = { [weak self] type in
            switch type {
            case .background(let color):
                self?.view.backgroundColor = color
                self?.selectColor = color!
            default:
                return
            }
        }

        DDPopManager.showActionSheet(withCustomView: b)
    }
    
    @objc private func saveToLibrary() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
