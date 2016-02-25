//
//  ViewController.swift
//  SICircularDemo
//
//  Created by isan on 16/2/25.
//  Copyright © 2016年 isan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SICircularViewDelegate {
    
    var bannerView:SICircularView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let bannerArray = self.fakeData()
        
        var bannerSize = CGSizeMake(370, 200)
        let screenSize = UIScreen.mainScreen().bounds.size
        let ratio = screenSize.width / bannerSize.width
        bannerSize = CGSizeMake(screenSize.width, bannerSize.height * ratio)
        
        
        bannerView = SICircularView(frame: CGRectMake(0, 20, bannerSize.width, bannerSize.height), bannerArray: bannerArray)
        
        self.view.addSubview(bannerView)
    }
    
    func fakeData() -> [BannerData] {
        var bannerArray:[BannerData] = []
        
        let banner1 = BannerData()
        banner1.image = "Google.jpg"
        banner1.link = "www.google.com.hk"
        bannerArray.append(banner1)
        
        let banner2 = BannerData()
        banner2.image = "Twitter.png"
        banner2.link = "https://twitter.com/3isan"
        bannerArray.append(banner2)
        
        let banner3 = BannerData()
        banner3.image = "Piratebay.jpg"
        banner3.link = "https://thepiratebay.se"
        bannerArray.append(banner3)
        
        return bannerArray
    }
    
    //MARK: SICircularViewDelegate
    func clickCurrentBanner(currentIndxe: Int) {
        //do sth
    }

}

