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
    
    fileprivate var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        flow.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flow)
        cv.backgroundColor = .red
        return cv
    }()
    
    var items: [SwipeItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.navigationItem.title = "NextViewController"
        
//        self.view.addSubview(self.topView)
//        self.topView.snp.makeConstraints { (make) in
//            make.leading.equalTo(100)
//            make.top.equalTo(100)
//            make.size.equalTo(CGSize(width: 60, height: 60))
//        }
//        
//        self.view.addSubview(self.followView)
//        self.followView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.topView.snp.bottom).offset(20)
//            make.centerX.equalTo(self.topView.snp.centerX)
//            make.size.equalTo(CGSize(width: 60, height: 60))
//        }
        let item1 = SwipeItem(placeHolder: "safe_loan_bg_image", imageUrl: "", reuseIdentifier: "SwipeCell")
        let item2 = SwipeItem(placeHolder: "safe_loan_bg_image", imageUrl: "", reuseIdentifier: "SwipeCell")
        let item3 = SwipeItem(placeHolder: "safe_loan_bg_image", imageUrl: "", reuseIdentifier: "SwipeCell")
        items = [item1, item2, item3]
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SwipeCell.self, forCellWithReuseIdentifier: "SwipeCell")
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

extension NextViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("cell is selected")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        (cell as! Updatable).update(withData: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

