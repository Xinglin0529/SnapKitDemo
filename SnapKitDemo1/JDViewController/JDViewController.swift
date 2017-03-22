//
//  JDViewController.swift
//  SnapKitDemo1
//
//  Created by 徐东东(金融科技科技中心研发团队移动研发组) on 17/3/22.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit

class JDViewController: UIViewController {
    
    fileprivate let animateView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "1.jpg")
        imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 300)
        return imageView
    }()
    
    var isShow = true
    var chart: LineChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(animateView)
        
        let chart: LineChartView = LineChartView(frame: CGRect(x: 10, y: animateView.frame.maxY + 20, width: UIScreen.main.bounds.size.width - 20, height: 200))
        self.view.addSubview(chart)
        self.chart = chart
    }
    
    private func addTransform() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -900
        transform = CATransform3DScale(transform, 0.95, 0.95, 0.95)
        transform = CATransform3DRotate(transform, CGFloat(15) * CGFloat(M_PI) / CGFloat(180), 1, 0, 0)
        return transform
    }
    
    private func removeTransform() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -900
        transform = CATransform3DScale(transform, 1, 1, 1)
        transform = CATransform3DRotate(transform, CGFloat(15) * CGFloat(M_PI) / CGFloat(180), 1, 0, 0)
        return transform
    }
    
    private func startJDAnimation() {
        UIView.animate(withDuration: 0.35, animations: { [unowned self] in
            self.animateView.layer.transform = self.addTransform()
        }) { [unowned self] (_) in
            UIView.animate(withDuration: 0.35, animations: { 
                self.animateView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
            })
        }
    }
    
    private func endJDAnimation() {
        UIView.animate(withDuration: 0.35, animations: { [unowned self] in
            self.animateView.layer.transform = self.removeTransform()
        }) { [unowned self] (_) in
            UIView.animate(withDuration: 0.35, animations: {
                self.animateView.transform = CGAffineTransform.identity;
            })
        }
    }
    
    private func transitionAnimation() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        animateView.layer.add(transition, forKey: "animation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        chart!.drawLine(withPoints: [CGPoint(x: 50, y: 100), CGPoint(x: 70, y: 50), CGPoint(x: 100, y: 150), CGPoint(x: 120, y: 20), CGPoint(x: 180, y: 100), CGPoint(x: 250, y: 50), CGPoint(x: 280, y: 100)])
        
//        transitionAnimation()
//        
//        if isShow {
//            isShow = false
//            startJDAnimation()
//        } else {
//            isShow = true
//            endJDAnimation()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
