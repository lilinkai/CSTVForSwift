//
//  HomeVC.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/26.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UIViewControllerTransitioningDelegate,UINavigationControllerDelegate {

    @IBOutlet var contentCollectionView: UICollectionView!
    
    let interactivePopTransition:UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    var progress:CGFloat = 0.0
    
    var lastContentOffset:CGFloat = 0.0

    let pushAnimator = VCAnimatedTransitioning()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        configContentCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.delegate = self
        super.viewWillLayoutSubviews()
        configNavStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeVC{
    
    func click() {
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func configNavStyle() {
        let leftItem1 = navBarItem(size: CGSize.init(width: 100, height: 50),
                                   normalImage: "img_player_loadingbg",
                                   highlightedImage: "img_player_loadingbg",
                                   target: self,
                                   selector: #selector(click))
        
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

extension HomeVC{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return pushAnimator
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivePopTransition
    }
}

extension HomeVC{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 20
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell;
    }
    
    func configContentCollectionView() {
        contentCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        
            
        
    }
 
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        
        lastContentOffset = scrollView.contentOffset.y
        
        if scrollView.contentOffset.y == 0 {
            let homeVC = HomeVC()
            self.navigationController?.pushViewController(homeVC, animated: true)
            print("开始拖动")
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView){
        if (lastContentOffset < scrollView.contentOffset.y) {
            print("向上滚动");
        }else{
            print("向下滚动");
            if scrollView.contentOffset.y <= 0 {
                progress = scrollView.contentOffset.y/contentCollectionView.frame.height
                scrollView.setContentOffset(CGPointZero, animated: false)
                interactivePopTransition.updateInteractiveTransition(-progress)
            }
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        interactivePopTransition.cancelInteractiveTransition()

    }

}









