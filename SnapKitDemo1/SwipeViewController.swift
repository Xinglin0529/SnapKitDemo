//
//  SwipeViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/6.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

protocol BackgroundColorSettable {
    func setBackgroundColor()
}

extension BackgroundColorSettable where Self: UIViewController {
    func setBackgroundColor() {
        self.view.backgroundColor = .white
    }
}

extension UIViewController: BackgroundColorSettable {}

class SwipeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        let item1 = SwipeItem(placeHolder: "safe_loan_bg_image", imageUrl: "", reuseIdentifier: "SwipeCell")
        let item2 = SwipeItem(placeHolder: "safe_loan_prediction_header_bgimage", imageUrl: "", reuseIdentifier: "SwipeCell")
        let item3 = SwipeItem(placeHolder: "safe_loan_huzhao_img", imageUrl: "", reuseIdentifier: "SwipeCell")

        let swipe = SwipeView()
        swipe.autoScroll = true
        swipe.pageIndicatorTintColor = .gray
        swipe.currentPageIndicatorTIntColor = .red
        swipe.callbackHandler = {
            print("current page is \($0)")
            self.navigationController?.pushViewController(PersonalViewController(), animated: true)
        }
        self.view.addSubview(swipe)
        swipe.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(64)
        }
        swipe.items = [item1, item2, item3]

        let mar1 = MarqueeItem(content: "safe_loan_bg_image", id: 1)
        let mar2 = MarqueeItem(content: "safe_loan_huzhao_img", id: 2)
        let mar3 = MarqueeItem(content: "safe_loan_prediction_header_bgimage", id: 3)

        let marquee = LDMarquee()
        marquee.textFont = 20
        marquee.textColor = .red
        marquee.marqueeBackgroundColor = .yellow
        marquee.callback = {
            print("selecte item is \($0)")
        }
        self.view.addSubview(marquee)
        marquee.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(84)
            make.height.equalTo(30)
        }
        marquee.messages = [mar1, mar2, mar3]
        
//        let imageV = UIImageView()
//        imageV.image = UIImage.init(named: "safe_loan_bg_image")
//        imageV.frame = CGRect(x: 100, y: 400, width: 80, height: 80)
//        self.view.addSubview(imageV)
    }
}
