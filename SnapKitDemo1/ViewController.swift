//
//  ViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/24.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "ViewController"
        
        let view = UIView()
        view.backgroundColor = .red
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(64)
            make.height.equalTo(200)
        }
        
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "SnapKit"
        label.backgroundColor = .yellow
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = .blue
        self.view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("Touch", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(ViewController.touchButton(sender:)), for: .touchUpInside)
        button.backgroundColor = .yellow
        viewBottom.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(viewBottom.snp.center)
            make.size.equalTo(CGSize(width: 200, height: 60))
        }
    }
    
    
    func swap<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }
    
    func touchButton(sender: UIButton) {
        //self.navigationController?.pushViewController(NextViewController(), animated: true)
//        let url = NSURL(string: "appApplication://")
//        if UIApplication.shared.canOpenURL(url as! URL) {
//            UIApplication.shared.open(url as! URL, options: ["key": "value"], completionHandler: nil)
//        }
        let cus = CustomAlert(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        DDPopManager.showCenterAlert(withCustomView: cus)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

