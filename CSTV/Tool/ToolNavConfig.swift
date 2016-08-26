//
//  ToolNavConfig.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/26.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    struct navBarItem {
        let size:CGSize
        let normalImage:String
        let highlightedImage:String
        let target:AnyObject?
        let selector:Selector
        
        func createBarButtonItem() -> UIBarButtonItem{
            let button = UIButton(type: .Custom)
            button.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            button.setImage(UIImage(named: normalImage), forState: .Normal)
            button.setImage(UIImage(named: highlightedImage), forState: .Highlighted)
            button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
            return UIBarButtonItem(customView: button)
        }
        
        /**
         创建占位baritem
         */
        static func createSpaceItem() -> UIBarButtonItem {
            let spaceItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            spaceItem.width = -15
            return spaceItem
        }
    }
    
    enum backStyle {
        case dismissStyle
        case popStyle
    }
    
    /**
    标题
     */
    func configTitle(navTitle title:String) {
        navigationItem.title = title
    }
    
    /**
     创建返回样式左按钮
     
     - parameter back_style: 返回形式
     */
    func configBackLeftItem(back_style back_style:backStyle) {
        
        let navItem:navBarItem
        
        switch back_style {
            
        case .dismissStyle:
            navItem = navBarItem(size: CGSize.init(width: 50, height: 50), normalImage: "btn_back_normal", highlightedImage: "btn_back_press", target: self, selector: #selector(dismiss))
        case .popStyle:
            navItem = navBarItem(size: CGSize.init(width: 50, height: 50), normalImage: "btn_back_normal", highlightedImage: "btn_back_press", target: self, selector: #selector(pop))
        }
        
        let backLeftItem = navItem.createBarButtonItem()
        
        navigationItem.leftBarButtonItems = [navBarItem.createSpaceItem(), backLeftItem]
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func configLeftItems(leftItems leftItems:[navBarItem]) {
        
        var items = leftItems.map{$0.createBarButtonItem()}
        
        items.insert(navBarItem.createSpaceItem(), atIndex: 0)
        
        navigationItem.leftBarButtonItems = items
    }
    
    
    func configRightItems(rightItems rightItems:[navBarItem]) {
        
        var items = rightItems.map{$0.createBarButtonItem()}
        
        items.insert(navBarItem.createSpaceItem(), atIndex: 0)
        
        navigationItem.rightBarButtonItems = items
    }
    
    func configNavStyle() {
        let leftItem1 = navBarItem(size: CGSize.init(width: 100, height: 50),
                                   normalImage: "img_player_loadingbg",
                                   highlightedImage: "img_player_loadingbg",
                                   target: nil,
                                   selector: nil)
        
        configLeftItems(leftItems: [leftItem1])
        
        
        let rightItem1 = navBarItem(size: CGSize.init(width: 40, height: 40),
                                    normalImage: "btn_top_search_n",
                                    highlightedImage: "btn_top_search_p",
                                    target: nil,
                                    selector: nil)
        let rightItem2 = navBarItem(size: CGSize.init(width: 40, height: 40),
                                    normalImage: "btn_top_task_n",
                                    highlightedImage: "btn_top_task_p",
                                    target: nil,
                                    selector: nil)
        let rightItem3 = navBarItem(size: CGSize.init(width: 40, height: 40),
                                    normalImage: "btn_top_bill_n",
                                    highlightedImage: "btn_top_bill_p",
                                    target: nil,
                                    selector: nil)
        let rightItem4 = navBarItem(size: CGSize.init(width: 40, height: 40),
                                    normalImage: "btn_top_info_n",
                                    highlightedImage: "btn_top_info_p",
                                    target: nil,
                                    selector: nil)
        
        configRightItems(rightItems: [rightItem1, rightItem2, rightItem3, rightItem4])
    }
}
