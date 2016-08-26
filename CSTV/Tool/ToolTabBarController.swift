//
//  ToolTabBarController.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/26.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class ToolTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeVC()
        let homeNavVC = ToolNavigationController(rootViewController: homeVC)
        homeNavVC.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "ic_main_recommend_n"), selectedImage: UIImage(named: "ic_main_recommend_s_n")?.imageWithRenderingMode(.AlwaysOriginal))
        
        let followVC = FollowVC()
        let followNavVC = ToolNavigationController(rootViewController: followVC)
        followNavVC.tabBarItem = UITabBarItem(title: "关注", image: UIImage(named: "ic_main_concern_n"), selectedImage: UIImage(named: "ic_main_concern_s_n")?.imageWithRenderingMode(.AlwaysOriginal))
        
        let gameVC = GameVC()
        let gameNavVC = ToolNavigationController(rootViewController: gameVC)
        gameNavVC.tabBarItem = UITabBarItem(title: "专区", image: UIImage(named: "ic_main_prefecture_n"), selectedImage: UIImage(named: "ic_main_prefecture_s_n")?.imageWithRenderingMode(.AlwaysOriginal))
        
        let mineVC = MineVC()
        let mineNavVC = ToolNavigationController(rootViewController: mineVC)
        mineNavVC.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "ic_main_mine_n"), selectedImage: UIImage(named: "ic_main_mine_s_n")?.imageWithRenderingMode(.AlwaysOriginal))
    
        viewControllers = [homeNavVC, followNavVC, gameNavVC, mineNavVC]
    
        tabBar.tintColor = UIColor.redColor()
        tabBar.barTintColor = UIColor.whiteColor()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
