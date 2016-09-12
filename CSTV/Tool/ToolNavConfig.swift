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
    struct customNavBarItem {
        let size:CGSize
        let normalImage:String
        let highlightedImage:String
        let target:AnyObject?
        let selector:Selector
        
        func createBarButtonItem() -> UIBarButtonItem{
            let button = UIButton(type: .custom)
            button.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            button.setImage(#imageLiteral(resourceName: "btn_top_task_p"))
            button.setImage(UIImage(named: normalImage), for: .normal)
            button.setImage(UIImage(named: highlightedImage), for: .highlighted)
            button.addTarget(target, action: selector, for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        }
        
        /**
         
         创建占位baritem
         */
        static func createSpaceItem() -> UIBarButtonItem {
            let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
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
        
        let navItem:customNavBarItem
        
        switch back_style {
            
        case .dismissStyle:
            navItem = customNavBarItem(size: CGSize.init(width: 50, height: 50), normalImage: "btn_back_normal", highlightedImage: "btn_back_press", target: self, selector: #selector(dismiss))
        case .popStyle:
            navItem = customNavBarItem(size: CGSize.init(width: 50, height: 50), normalImage: "btn_back_normal", highlightedImage: "btn_back_press", target: self, selector: #selector(pop))
        }
        
        let backLeftItem = navItem.createBarButtonItem()
        
        navigationItem.leftBarButtonItems = [customNavBarItem.createSpaceItem(), backLeftItem]
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func configLeftItems(leftItems:[customNavBarItem]) {
        
        var items = leftItems.map{$0.createBarButtonItem()}
        
        items.insert(customNavBarItem.createSpaceItem(), atIndex: 0)
        
        navigationItem.leftBarButtonItems = items
    }
    
    
    func configRightItems(rightItems:[customNavBarItem]) {
        
        var items = rightItems.map{$0.createBarButtonItem()}
        
        items.insert(customNavBarItem.createSpaceItem(), at: 0)
        
        navigationItem.rightBarButtonItems = items
    }
}
