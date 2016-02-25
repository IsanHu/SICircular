//
//  SICircularView.swift
//  SICircularDemo
//
//  Created by isan on 16/2/25.
//  Copyright © 2016年 isan. All rights reserved.
//

import UIKit

let AutoTimeInterval = 2.5          //全局的时间间隔

@objc protocol SICircularViewDelegate {
    optional func BannerClicked(indxe: Int)
}

class SICircularView: UIView, UIScrollViewDelegate {
    
    var delegate: SICircularViewDelegate?
    
    var contentScrollView: UIScrollView!
    var bannerArray: [BannerData]! {
        /**
        *  如果数据源改变，则需要改变scrollView、分页指示器的数量
        */
        didSet {
            self.setBannerData()
        }
    }
    
    var indexOfCurrentBanner: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            self.pageIndicator.currentPage = indexOfCurrentBanner
        }
    }
    
    var currentImageView:   UIImageView!
    var lastImageView:      UIImageView!
    var nextImageView:      UIImageView!
    
    var pageIndicator:      UIPageControl!          //页数指示器
    
    var timer:              NSTimer?                //计时器
    
    
    /*********************************** Begin ****************************************/
    //MARK:- Begin
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, bannerArray: [BannerData]) {
        self.init(frame: frame)
        // 默认显示第一张图片
        self.indexOfCurrentBanner = 0
        self.setUpCircleView()
        
        self.bannerArray = bannerArray
        self.setBannerData()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.currentImageView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.contentScrollView.frame.height)
        self.lastImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.contentScrollView.frame.height)
        self.nextImageView.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.contentScrollView.frame.height)
        self.pageIndicator.frame = CGRectMake(self.frame.size.width - 20 * CGFloat(bannerArray.count), self.frame.size.height - 30, 20 * CGFloat(bannerArray.count), 20)
    }
    
    func setBannerData() {
        if bannerArray.count <= 1 {
            contentScrollView.scrollEnabled = false
            timer?.invalidate()
            timer = nil
        }else{
            //设置计时器
            if self.timer == nil {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(AutoTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
            }
            contentScrollView.scrollEnabled = true
        }
        
        self.pageIndicator.frame = CGRectMake(self.frame.size.width - 20 * CGFloat(bannerArray.count), self.frame.size.height - 30, 20 * CGFloat(bannerArray.count), 20)
        self.pageIndicator?.numberOfPages = self.bannerArray.count
        self.indexOfCurrentBanner = 0 //重置成第一张
        self.setScrollViewOfImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Privite Methods
    private func setUpCircleView() {
        self.contentScrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.pagingEnabled = true
        contentScrollView.backgroundColor = UIColor.clearColor()
        contentScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(contentScrollView)
        
        self.currentImageView = UIImageView()
        currentImageView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.contentScrollView.frame.height)
        currentImageView.userInteractionEnabled = true
        currentImageView.contentMode = UIViewContentMode.ScaleAspectFill
        currentImageView.clipsToBounds = true
        contentScrollView.addSubview(currentImageView)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: Selector("bannerTapAction"))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView()
        lastImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.contentScrollView.frame.height)
        lastImageView.contentMode = UIViewContentMode.ScaleAspectFill
        lastImageView.clipsToBounds = true
        contentScrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView()
        nextImageView.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.contentScrollView.frame.height)
        nextImageView.contentMode = UIViewContentMode.ScaleAspectFill
        nextImageView.clipsToBounds = true
        contentScrollView.addSubview(nextImageView)
        
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        
        //设置分页指示器
        self.pageIndicator = UIPageControl(frame: CGRectMake(self.frame.size.width - 20, self.frame.size.height - 30, 20 , 20))
        pageIndicator.hidesForSinglePage = true
        pageIndicator.backgroundColor = UIColor.clearColor()
        self.addSubview(pageIndicator)
    }
    
    private func getBanner(index : Int) -> BannerData? {
        if index >= 0 && index < self.bannerArray.count {
            return self.bannerArray[index]
        }else {
            return nil
        }
    }
    
    private func setImageViewData(banner: BannerData, imageView: UIImageView) {
        imageView.image = UIImage(named: banner.image)
    }
    
    //MARK: 设置图片
    private func setScrollViewOfImage(){
        
        if let currentBanner = self.getBanner(self.indexOfCurrentBanner) {
            self.setImageViewData(currentBanner, imageView:self.currentImageView)
        }
        
        if let nextBanner = self.getBanner(self.getNextBannerIndex(indexOfCurrentBanner: self.indexOfCurrentBanner)) {
            self.setImageViewData(nextBanner, imageView:self.nextImageView)
        }
        
        if let laseBanner = self.getBanner(self.getLastBannerIndex(indexOfCurrentBanner: self.indexOfCurrentBanner)) {
            self.setImageViewData(laseBanner, imageView:self.lastImageView)
        }
    }
    
    // 得到上一张图片的下标
    private func getLastBannerIndex(indexOfCurrentBanner index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.bannerArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    private func getNextBannerIndex(indexOfCurrentBanner index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.bannerArray.count ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width*2, 0), animated: true)
    }
    
    //MARK:- Public Methods
    func bannerTapAction(){
        print(self.bannerArray[indexOfCurrentBanner].image)
        self.delegate?.BannerClicked?(indexOfCurrentBanner)
    }

     //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentBanner = self.getLastBannerIndex(indexOfCurrentBanner: self.indexOfCurrentBanner)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentBanner = self.getNextBannerIndex(indexOfCurrentBanner: self.indexOfCurrentBanner)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间的那个banner
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(AutoTimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
    
}