//
//  HomeVC.swift
//  CSTV
//
//  Created by 李林凯 on 16/8/26.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
 
    @IBOutlet var contentCollectionView: UICollectionView!
    
    var isPanAnimation = false
    
    var beginLocation:CGPoint = CGPoint.zero    //记录起始点
    
    var count = 0
    private var nextColor: UIColor {
        return [
            UIColor(red:0.83, green:0.88, blue:0.61, alpha:1.00),
            UIColor(red:0.78, green:0.92, blue:0.94, alpha:1.00),
            UIColor(red:0.30, green:0.46, blue:0.67, alpha:1.00)
            ][max(count, 0) % 3]
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        configContentCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 50
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = nextColor
        return cell;
    }
    
    func configContentCollectionView() {
        
        contentCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        contentCollectionView.panGestureRecognizer.addTarget(self, action: #selector(collectionViewPanGesTure(_:)))
        
        addObserve()
      
    }

}

extension HomeVC{
    
    func addObserve() {
        contentCollectionView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    func removeObserve() {
        contentCollectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

extension HomeVC{
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            
            if let offSet = change![NSKeyValueChangeNewKey] {
                let offset = (offSet as! NSValue).CGPointValue()
                if offset.y <= 0 && contentCollectionView.dragging && contentCollectionView.tracking{
                    
                    contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                    
                    isPanAnimation = true
                    removeObserve()
                
                    beginLocation = contentCollectionView.panGestureRecognizer.locationInView(view)
                    
                    let bgButton = UIButton.init(type: .Custom)
                    bgButton.backgroundColor = UIColor.blackColor()
                    bgButton.alpha = 0.7
                    bgButton.tag = 2000
                    view.insertSubview(bgButton, aboveSubview: contentCollectionView);
                    bgButton.snp_makeConstraints(closure: { (make) in
                        make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                    })
                    
                    
                    let snapshot = contentCollectionView.snapshotViewAfterScreenUpdates(false)
                    snapshot.tag = 1000
                    view.insertSubview(snapshot, aboveSubview: bgButton)
                    snapshot.frame.origin = CGPoint(x: 0, y: 64)
        
                    count += 1
                    contentCollectionView.reloadData()
                    
                }
            }
        }
    }
    
}

extension HomeVC{
    
    func collectionViewPanGesTure(pan:UIPanGestureRecognizer) {
        
        switch pan.state {
        case .Began:
            ()
        case .Changed:
            if isPanAnimation {
                
                let location = pan.locationInView(view)
                let distance = view.frame.height - beginLocation.y
                
                let progressHeight = (location.y - beginLocation.y) / distance * view.frame.height
                
                let bgButton = view.viewWithTag(2000)
                bgButton?.alpha = 1 - progressHeight/distance
                
                contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                contentCollectionView.transform = CGAffineTransformMakeScale(progressHeight/distance, progressHeight/distance)
                
                let snapView = view.viewWithTag(1000)
                snapView?.transform = CGAffineTransformMakeTranslation(0, progressHeight)
           
            }
        case .Ended:
            if isPanAnimation {
                
                isPanAnimation = false
                
                let snapView = view.viewWithTag(1000)
                snapView?.removeFromSuperview()
                
                contentCollectionView.transform = CGAffineTransformMakeScale(1, 1)
                
                let bgButton = view.viewWithTag(2000)
                bgButton?.removeFromSuperview()
                
                addObserve()
            }
        default:
            ()
        }
        
    }
}









