//
//  LineChartView.swift
//  SnapKitDemo1
//
//  Created by 徐东东(金融科技科技中心研发团队移动研发组) on 17/3/22.
//  Copyright © 2017年 com. All rights reserved.
//

import UIKit

private let margin: CGFloat = 30.0

class LineChartView: UIView {
    
    let XRules: [String] = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
    let YRules: [String] = ["600", "500", "400", "300", "200", "100"];
    let gradientView: UIView = UIView();
    
    let lineLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.green.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 0
        shape.lineCap = kCALineCapRound
        shape.lineJoin = kCALineJoinRound
        return shape
    }()
    
    let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.orange.cgColor, UIColor.red.cgColor]
        g.startPoint = CGPoint(x: 0, y: 0)
        g.endPoint = CGPoint(x: 1, y: 0)
        return g
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addGradientView()
        addDashedLine()
        addXRule()
        addYRule()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLine(withPoints: [CGPoint]) {
        if lineLayer.superlayer != nil {
            lineLayer.removeFromSuperlayer()
        }
        gradientView.layer.addSublayer(lineLayer)
        let yDistance: CGFloat = (frame.size.height - margin) / 6
        let y: CGFloat = CGFloat(arc4random() % 5) * yDistance
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: y))
        for point in withPoints {
            path.addLine(to: point)
        }
        path.stroke()
        lineLayer.lineWidth = 1
        lineLayer.path = path.cgPath
        addAnimation()
    }
    
    private func addAnimation() {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 3
        animation.fillMode = kCAFillModeForwards
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: 1)
        animation.isRemovedOnCompletion = false
        lineLayer.add(animation, forKey: "strokeEnd")
    }
    
    private func addXRule() {
        let xDistance: CGFloat = (frame.size.width - 2 * margin) / 12
        for i in 0..<XRules.count {
            let label: UILabel = UILabel()
            label.text = XRules[i]
            label.frame = CGRect(x: margin + xDistance * CGFloat(i), y: frame.size.height - margin / 2, width: xDistance, height: 10)
            label.font = UIFont.systemFont(ofSize: 8)
            label.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI) * 0.3)
            self.addSubview(label)
        }
    }
    
    private func addYRule() {
        let yDistance: CGFloat = (frame.size.height - margin) / 6
        for i in 0..<YRules.count {
            let label: UILabel = UILabel()
            label.text = YRules[i]
            label.textAlignment = .right
            label.frame = CGRect(x: 0, y: yDistance * CGFloat(i), width: margin - 5, height: 10)
            label.font = UIFont.systemFont(ofSize: 8)
            self.addSubview(label)
        }
    }
    
    private func addGradientView() {
        gradientView.frame = CGRect(x: margin, y: 0, width: frame.size.width - 2 * margin, height: frame.size.height - margin)
        self.addSubview(gradientView)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private func addDashedLine() {
        let yDistance: CGFloat = (frame.size.height - margin) / 6
        for index in 0..<YRules.count {
            if index == 0 {
                continue;
            }
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: yDistance * CGFloat(index)))
            path.addLine(to: CGPoint(x: gradientLayer.frame.size.width, y: yDistance * CGFloat(index)))
//            path.setLineDash(nil, count: 2, phase: 10)
            shapeLayer.path = path.cgPath
            
            gradientLayer.addSublayer(shapeLayer)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.red.cgColor)
        context.move(to: CGPoint(x: margin, y:0))
        context.addLine(to: CGPoint(x: margin, y: frame.size.height - margin))
        context.addLine(to: CGPoint(x: frame.size.width - margin, y: frame.size.height - margin))
        context.strokePath()
    }
}
