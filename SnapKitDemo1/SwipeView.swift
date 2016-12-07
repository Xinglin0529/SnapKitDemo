//
//  SwipeView.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/6.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

extension String {
    func toClass() -> AnyClass? {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let classStringName = "_TtC\(appName.characters.count)\(appName)\(self.characters.count)\(self)"
            let cls: AnyClass? = NSClassFromString(classStringName)
            return cls
        }
        return nil
    }
}

protocol Updatable {
    func update(withData data: SwipeItem)
}

class SwipeBase: UICollectionViewCell, Updatable {
    var data: SwipeItem?
    func update(withData data: SwipeItem) {
        self.data = data
    }
}

struct SwipeItem {
    var placeHolder: String
    var imageUrl: String
    var reuseIdentifier: String
}

fileprivate struct SwipeConfig {
    static let swipeTimeInterval: TimeInterval = 3
}

class SwipeView: UIView {
    
    var autoScroll: Bool = true {
        didSet {
            if items.count <= 1 { return }
            scrollToPage(page: currentPage)
            if !autoScroll { return }
            removeTimer()
            addTimer()
        }
    }
    
    var items: [SwipeItem] = [] {
        didSet {
            reloadData(items)
        }
    }
    
    var pageIndicatorTintColor: UIColor = .white {
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    var currentPageIndicatorTIntColor: UIColor = .blue {
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    var callbackHandler:((Int) -> ())?
    
    fileprivate var currentPage: Int = 0
    
    fileprivate var timer: Timer?
    
    fileprivate let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        return pc
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        flow.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(pageControl)
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTIntColor
        pageControl.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.height.equalTo(10)
        }
    }
    
    private func reloadData(_ data: [SwipeItem]) {
        pageControl.numberOfPages = data.count
        registerCollectionViewCells(items: data)
        collectionView.reloadData()
        layoutIfNeeded()
        
        if data.count <= 1 { return }
        scrollToPage(page: data.count * 100)
        if !autoScroll { return }
        removeTimer()
        addTimer()
    }
    
    private func registerCollectionViewCells(items: [SwipeItem]) {
        items.forEach { [weak self] item in
            let cls: AnyClass? = item.reuseIdentifier.toClass()
            self?.collectionView.register(cls, forCellWithReuseIdentifier: item.reuseIdentifier)
        }
    }
    
    fileprivate func scrollToPage(page: Int) {
        let offsetX = contentWidth() * CGFloat(page)
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    fileprivate func itemAtIndexPath(indexPath: IndexPath) -> SwipeItem {
        let item = indexPath.item % items.count
        return items[item]
    }
    
    fileprivate func contentWidth() -> CGFloat {
        return frame.size.width
    }
    
    fileprivate func contentHeight() -> CGFloat {
        return frame.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwipeView {
    fileprivate func delay(_ timeInterval: TimeInterval, closure: @escaping () -> ()) {
        let t = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: t, execute: closure)
    }
}

// MARK: - Create Timer
extension SwipeView {
    fileprivate func addTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: SwipeConfig.swipeTimeInterval, repeats: true, block: { [weak self] (timer) in
            self?.timerStartWork(timer: timer)
        })
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc private func timerStartWork(timer: Timer) {
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + contentWidth()
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - UIScrollViewDelegate
extension SwipeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + contentWidth() * 0.5
        
        currentPage = Int(offsetX / contentWidth())

        // 2.计算pageControl的currentIndex
        pageControl.currentPage = currentPage % items.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if items.count <= 1 || !autoScroll { return }
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if items.count <= 1 || !autoScroll { return }
        addTimer()
    }
}


// MARK: - UICollectionViewDelegate
extension SwipeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if callbackHandler != nil { callbackHandler!(pageControl.currentPage) }
    }
}

// MARK: - UICollectionViewDataSource
extension SwipeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count == 1 ? 1 : items.count * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemAtIndexPath(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        (cell as! Updatable).update(withData: item)
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SwipeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentWidth(), height: contentHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
