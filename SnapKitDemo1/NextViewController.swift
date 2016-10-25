//
//  NextViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/10/24.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    fileprivate lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    fileprivate lazy var followView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.navigationItem.title = "NextViewController"
        
        self.view.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.leading.equalTo(100)
            make.top.equalTo(100)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        self.view.addSubview(self.followView)
        self.followView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(20)
            make.centerX.equalTo(self.topView.snp.centerX)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.topView.snp.updateConstraints { (make) in
            make.top.equalTo(300)
        }
        
        UIView.animate(withDuration: 1, animations: { 
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            }) { [unowned self] (complete) in
                self.topView.snp.updateConstraints { (make) in
                    make.top.equalTo(100)
                }
                UIView.animate(withDuration: 1, animations: { 
                    self.view.layoutIfNeeded()
                    self.view.updateConstraints()
                    }, completion: { (complete) in
                        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: .curveEaseOut, animations: {
                            self.topView.transform = CGAffineTransform(scaleX: 2, y: 2)
                            }, completion: { [unowned self](complete) in
                                UIView.animate(withDuration: 1, animations: { 
                                    self.topView.transform = CGAffineTransform.identity
                                    }, completion: nil)
                        })
                })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
