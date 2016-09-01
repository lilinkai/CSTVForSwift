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
                if offset.y < 0 && contentCollectionView.dragging && contentCollectionView.tracking{
                    
                    isPanAnimation = true
                    removeObserve()
                    
                    count += 1
                    contentCollectionView.reloadData()
                    
                    contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                    
                    beginLocation = contentCollectionView.panGestureRecognizer.locationInView(view)
                    print("beginLocation ======\(beginLocation)")
                    
                    let snapshot = contentCollectionView.snapshotViewAfterScreenUpdates(false)
                    snapshot.tag = 1000
                    view.insertSubview(snapshot, aboveSubview: contentCollectionView)
                    snapshot.frame.origin = CGPoint(x: 0, y: 64)
                    
                    
                    
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
            
                contentCollectionView.setContentOffset(CGPoint.zero, animated: false)
                
                let snapView = view.viewWithTag(1000)
                
                snapView?.transform = CGAffineTransformMakeTranslation(0, progressHeight)
                
              //  print("正在滑动 ==== \(location.y)")
                
            }
        case .Ended:
            if isPanAnimation {
                print("结束滑动")
                isPanAnimation = false
               // count -= 1
                let snapView = view.viewWithTag(1000)
                snapView?.removeFromSuperview()
                
                addObserve()
            }
        default:
            ()
        }
        
    }
}









