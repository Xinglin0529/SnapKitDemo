//
//  SettingBrush.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/10.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

enum SettingType {
    case brush(Int, UIColor?)
    case background(UIColor?)
}

class SettingBrush: DDBasePopView {
    var fontWeight: Int = 1
    var color: UIColor = .white
    var completion: ((SettingType) -> ())?
    private var settingType: SettingType?
    private var sliders: [UISlider] = []
    private var labels: [UILabel] = []
    
    init(frame: CGRect, type: SettingType) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.settingType = type
        switch type {
            case let .brush(fontWeight, color):
                if fontWeight > 1 {
                    self.fontWeight = fontWeight
                }
                if let color = color {
                    self.color = color
                }
            case let .background(color):
                if let color = color {
                    self.color = color
                }
        }
        setupSubViews(with: type)
    }
    
    @objc private func setupBrushFontWeight(slider: UISlider) {
        self.fontWeight = Int(slider.value)
        (self.viewWithTag(1001) as! UILabel).text = "\(self.fontWeight)"
    }
    
    @objc private func setupBackColor(slider: UISlider) {
        let tag = slider.tag - 10
        labels[tag].text = "\(Int(sliders[tag].value))"
        let red: Float = sliders[0].value
        let green: Float = sliders[1].value
        let blue: Float = sliders[2].value
        let currentColor = UIColor.init(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1)
        self.viewWithTag(100)?.backgroundColor = currentColor
        self.color = currentColor
    }
    
    private func setupSubViews(with type: SettingType) {
        switch type {
        case .brush(_, _):
            buildBrushUI()
        default:
            buildBackImageUI()
        }
    }
    
    @objc private func selectImageFromAlbum() {
        
    }
    
    @objc private func completeButtonClick() {
        if completion != nil {
            switch settingType! {
            case .brush(_, _):
                completion!(.brush(fontWeight, color))
            default:
                completion!(.background(color))
            }
        }
        DDPopManager.hideAllPopView()
    }
    
    private func buildBrushUI() {
        let fontWeightLabel = UILabel()
        fontWeightLabel.text = "画笔粗细"
        fontWeightLabel.textAlignment = .left
        self.addSubview(fontWeightLabel)
        
        let minLabel = UILabel()
        minLabel.text = "1"
        minLabel.textAlignment = .left
        self.addSubview(minLabel)
        
        let fontSlider = UISlider()
        fontSlider.minimumValue = 1
        fontSlider.maximumValue = 20
        fontSlider.minimumTrackTintColor = .blue
        fontSlider.maximumTrackTintColor = .gray
        fontSlider.addTarget(self, action: #selector(SettingBrush.setupBrushFontWeight(slider:)), for: .valueChanged)
        self.addSubview(fontSlider)
        fontSlider.setValue(Float(fontWeight), animated: true)
        
        let maxLabel = UILabel()
        maxLabel.tag = 1001
        maxLabel.text = "\(self.fontWeight)"
        maxLabel.textAlignment = .right
        self.addSubview(maxLabel)
        
        let colorLabel = UILabel()
        colorLabel.text = "画笔颜色"
        colorLabel.textAlignment = .left
        self.addSubview(colorLabel)
        
        let sampleColor = UIView()
        sampleColor.layer.borderColor = UIColor.black.cgColor
        sampleColor.layer.borderWidth = 1
        sampleColor.tag = 100
        sampleColor.backgroundColor = self.color
        self.addSubview(sampleColor)
        
        let v = buildSliderUI()
        self.addSubview(v)
        
        let completeBtn = completeButton()
        self.addSubview(completeBtn)
        
        fontWeightLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
        }
        
        minLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(fontWeightLabel.snp.bottom).offset(10)
        }
        
        fontSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(minLabel.snp.trailing).offset(5)
            make.trailing.equalTo(maxLabel.snp.leading).offset(-5)
            make.centerY.equalTo(minLabel.snp.centerY)
        }
        
        maxLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(minLabel.snp.centerY)
        }
        
        colorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(minLabel.snp.bottom).offset(10)
        }
        
        sampleColor.snp.makeConstraints { (make) in
            make.top.equalTo(colorLabel.snp.bottom).offset(5)
            make.leading.equalTo(10)
            make.size.equalTo(CGSize(width: 40, height: 20))
        }
        
        v.snp.makeConstraints { (make) in
            make.top.equalTo(sampleColor.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(120)
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(v.snp.bottom).offset(10)
            make.trailing.equalTo(-10)
        }
    }
    
    private func completeButton() -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(SettingBrush.completeButtonClick), for: .touchUpInside)
        return button
    }
    
    private func buildBackImageUI() {
        let button = UIButton.init(type: .custom)
        button.setTitle("从相册中选择背景", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(SettingBrush.selectImageFromAlbum), for: .touchUpInside)
        self.addSubview(button)
        
        let v = buildSliderUI()
        self.addSubview(v)
        
        let completeBtn = completeButton()
        self.addSubview(completeBtn)
        
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(10)
        }
        
        v.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(120)
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(v.snp.bottom).offset(10)
            make.trailing.equalTo(-10)
        }
    }
    
    private func buildSliderUI() -> UIView {
        let bgView = UIView()
        self.addSubview(bgView)
        
        let minTrackColor = [UIColor.red, UIColor.green, UIColor.blue]
        var components = self.color.cgColor.components
        if (components?.count)! < 4 {
            components = [0, 0, 0, 1]
        } else {
            components = components!.map { CGFloat($0 * 255) }
        }
        for i in 0..<3 {
            let colorSlider = UISlider()
            colorSlider.tag = i + 10
            colorSlider.minimumValue = 0
            colorSlider.maximumValue = 255
            colorSlider.minimumTrackTintColor = minTrackColor[i]
            colorSlider.maximumTrackTintColor = .gray
            colorSlider.addTarget(self, action: #selector(SettingBrush.setupBackColor(slider:)), for: .valueChanged)
            bgView.addSubview(colorSlider)
            sliders.append(colorSlider)

            let label = UILabel()
            label.tag = i + 20
            label.text = "\(Int(components![i]))"
            label.textAlignment = .right
            bgView.addSubview(label)
            labels.append(label)

            colorSlider.snp.makeConstraints({ (make) in
                make.leading.equalTo(10)
                make.top.equalTo(10 + 45 * i)
                make.trailing.equalTo(label.snp.leading).offset(-5)
                make.height.equalTo(20)
            })
            
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(colorSlider.snp.centerY)
                make.trailing.equalTo(-10)
            })
        }
        
        for j in 0..<3 {
            sliders[j].setValue(Float(components![j]), animated: true)
        }
        return bgView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
